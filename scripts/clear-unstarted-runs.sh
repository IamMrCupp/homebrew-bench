#!/bin/sh
# Delete the CI runs on a bump branch that never started a job.
#
#   sh scripts/clear-unstarted-runs.sh bump/benchhud-1.2.3
#   DRY_RUN=1 sh scripts/clear-unstarted-runs.sh bump/benchhud-1.2.3
#
# GitHub holds the workflows of a pull request opened with the Actions token
# until someone approves them. Nobody does: the bump workflow runs the same
# checks itself, then merges. When the branch goes, the held run ends as a
# failure with no jobs in it, and sits red beside a bump that passed (#23).
#
# Only a run with no jobs is deleted. One that somebody approved has jobs and a
# log, and is kept.
set -eu

if [ $# -ne 1 ]; then
    echo "usage: clear-unstarted-runs.sh bump/<name>" >&2
    exit 2
fi
branch=$1
case "$branch" in
    bump/*) ;;
    *)
        echo "not a bump branch: $branch" >&2
        exit 2
        ;;
esac
repo=${GITHUB_REPOSITORY:-IamMrCupp/homebrew-bench}

# This branch's pull-request runs, through a jq filter.
runs() {
    gh api -X GET "repos/$repo/actions/runs" \
        -f branch="$branch" -f event=pull_request -f per_page=100 --jq "$1"
}

# The held run ends a moment after the branch is deleted. Give it a minute.
tries=${TRIES:-12}
while [ "$tries" -gt 0 ]; do
    unfinished=$(runs '[.workflow_runs[] | select(.status != "completed")] | length')
    [ "$unfinished" -eq 0 ] && break
    tries=$((tries - 1))
    sleep "${WAIT:-5}"
done

ids=$(runs '.workflow_runs[].id')
failed=0
for id in $ids; do
    jobs=$(gh api "repos/$repo/actions/runs/$id/jobs" --jq .total_count)
    if [ "$jobs" -ne 0 ]; then
        echo "run $id: $jobs jobs, kept"
    elif [ -n "${DRY_RUN:-}" ]; then
        echo "run $id: no jobs, would delete"
    elif gh api -X DELETE "repos/$repo/actions/runs/$id" >/dev/null; then
        echo "run $id: no jobs, deleted"
    else
        echo "run $id: no jobs, but it couldn't be deleted" >&2
        failed=1
    fi
done
exit "$failed"
