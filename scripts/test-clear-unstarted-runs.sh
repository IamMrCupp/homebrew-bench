#!/bin/sh
# Tests for clear-unstarted-runs.sh, against a stand-in for `gh`.
#
#   sh scripts/test-clear-unstarted-runs.sh
#
# The stand-in answers from files in a scratch directory and writes down every
# call and every delete. Needs jq, which the real gh has built in.
set -eu

here=$(cd "$(dirname "$0")" && pwd)
script=$here/clear-unstarted-runs.sh
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
failures=0

mkdir "$work/bin"
cat > "$work/bin/gh" <<'STUB'
#!/bin/sh
# gh api [-X METHOD] <path> [-f key=value]... [--jq filter]
echo "$*" >> "$STUB/calls"
shift
method=GET
path=
filter=.
while [ $# -gt 0 ]; do
    case "$1" in
        -X) method=$2; shift 2 ;;
        -f) shift 2 ;;
        --jq) filter=$2; shift 2 ;;
        *) path=$1; shift ;;
    esac
done
case "$method $path" in
    "DELETE "*)
        id=${path##*/}
        [ -e "$STUB/undeletable-$id" ] && exit 1
        echo "$id" >> "$STUB/deleted"
        ;;
    "GET "*/jobs)
        id=${path%/jobs}
        id=${id##*/}
        echo "{\"total_count\": $(cat "$STUB/jobs-$id")}" | jq -r "$filter"
        ;;
    "GET "*/actions/runs)
        [ -e "$STUB/list-fails" ] && exit 1
        n=$(($(cat "$STUB/lists" 2>/dev/null || echo 0) + 1))
        echo "$n" > "$STUB/lists"
        file=$STUB/runs-$n.json
        [ -e "$file" ] || file=$STUB/runs.json
        jq -r "$filter" < "$file"
        ;;
    *)
        echo "the stand-in has no answer for: $method $path" >&2
        exit 64
        ;;
esac
STUB
chmod +x "$work/bin/gh"

# Start a case: a clean scratch directory with the given runs in it.
#   given '<id> <status> <jobs>' ...
given() {
    STUB=$work/case
    rm -rf "$STUB"
    mkdir "$STUB"
    : > "$STUB/calls"
    : > "$STUB/deleted"
    dry=
    runs_file "$STUB/runs.json" "$@"
}

# Write a runs listing; also records each run's job count.
runs_file() {
    out=$1
    shift
    list=
    for run in "$@"; do
        # shellcheck disable=SC2086  # split "<id> <status> <jobs>" on purpose
        set -- $run
        list="$list{\"id\": $1, \"status\": \"$2\"},"
        echo "$3" > "$STUB/jobs-$1"
    done
    echo "{\"workflow_runs\": [${list%,}]}" > "$out"
}

# Run the script; its exit status lands in $status, its output in $STUB/out.
# Set dry=1 first for a dry run; `given` clears it.
run() {
    status=0
    STUB=$STUB PATH=$work/bin:$PATH WAIT=0 GITHUB_REPOSITORY=owner/tap DRY_RUN=$dry \
        sh "$script" "$@" > "$STUB/out" 2>&1 || status=$?
}

check() {
    what=$1
    shift
    if "$@"; then
        echo "ok   $what"
    else
        echo "FAIL $what"
        sed 's/^/       /' "$STUB/out" "$STUB/calls"
        failures=$((failures + 1))
    fi
}

deleted() { [ "$(tr '\n' ' ' < "$STUB/deleted")" = "$1" ]; }
exited() { [ "$status" -eq "$1" ]; }
said() { grep -qF "$1" "$STUB/out"; }
called() { grep -qF -- "$1" "$STUB/calls"; }
calls() { [ "$(grep -c -- "$1" "$STUB/calls")" -eq "$2" ]; }

given '11 completed 0' '12 completed 3' '13 completed 0'
run bump/benchhud-1.2.3
check "runs with no jobs are deleted" deleted "11 13 "
check "a run with jobs is kept, and says so" said "run 12: 3 jobs, kept"
check "it exits clean" exited 0
check "it asks for this branch's runs" called "branch=bump/benchhud-1.2.3"
check "and only the pull request's" called "event=pull_request"
check "in the repository it runs in" called "repos/owner/tap/actions/runs"

given '11 completed 0'
dry=1
run bump/benchhud-1.2.3
check "a dry run deletes nothing" deleted ""
check "a dry run says what it would do" said "run 11: no jobs, would delete"

given
run bump/benchhud-1.2.3
check "no runs is not an error" exited 0
check "and nothing is deleted" deleted ""

given '11 completed 0'
run fix/something
check "another branch is refused" exited 2
check "before anything is asked" calls . 0

given '11 completed 0'
run
check "no branch is refused" exited 2
check "before anything is asked (no branch)" calls . 0
check "and says how it's used" said "usage: clear-unstarted-runs.sh bump/<name>"

# The held run is still open on the first two looks, and done on the third.
given '11 completed 0'
runs_file "$STUB/runs-1.json" '11 action_required 0'
runs_file "$STUB/runs-2.json" '11 action_required 0'
run bump/benchhud-1.2.3
check "it waits for the run to end" calls "actions/runs -f" 4
check "then deletes it" deleted "11 "

# It never ends: after twelve looks the delete is tried anyway.
given '11 queued 0'
run bump/benchhud-1.2.3
check "it stops waiting after twelve looks" calls "actions/runs -f" 13
check "and tries the delete anyway" deleted "11 "

given '11 completed 0' '12 completed 0'
: > "$STUB/undeletable-11"
run bump/benchhud-1.2.3
check "a delete that fails doesn't stop the next" deleted "12 "
check "and the script fails" exited 1
check "and says which run" said "run 11: no jobs, but it couldn't be deleted"

given '11 completed 0'
: > "$STUB/list-fails"
run bump/benchhud-1.2.3
check "a listing that fails is a failure, not an empty list" [ "$status" -ne 0 ]
check "and deletes nothing" deleted ""

if [ "$failures" -gt 0 ]; then
    echo "$failures failed"
    exit 1
fi
echo "all passed"
