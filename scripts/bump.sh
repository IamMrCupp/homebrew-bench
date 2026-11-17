#!/bin/sh
# Point the formula and each cask at its project's newest release.
#
#   sh scripts/bump.sh          # edits the files in place; prints what changed
#
# A formula builds from the release's source tarball. A cask installs the
# release's .dmg, so it only moves to a release that carries one: a release is
# published a few minutes before its installers are attached.
set -eu

changed=""

sha_of() { curl -fsSL "$1" | shasum -a 256 | cut -d' ' -f1; }

# --- bench-setup (formula) -------------------------------------------------
file=Formula/bench-setup.rb
tag=$(gh release view -R IamMrCupp/bench-suite --json tagName -q .tagName)
url="https://github.com/IamMrCupp/bench-suite/archive/refs/tags/$tag.tar.gz"
if ! grep -qF "$url" "$file"; then
    sha=$(sha_of "$url")
    sed -i.bak -E "s|^  url \".*\"|  url \"$url\"|; s|^  sha256 \".*\"|  sha256 \"$sha\"|" "$file"
    rm -f "$file.bak"
    changed="$changed bench-setup-${tag#v}"
fi

# --- casks -------------------------------------------------------------------
for file in Casks/*.rb; do
    [ -e "$file" ] || continue
    repo=$(sed -n 's|^ *homepage "https://github.com/\(.*\)"$|\1|p' "$file")
    have=$(sed -n 's/^ *version "\(.*\)"$/\1/p' "$file")
    for tag in $(gh release list -R "$repo" --exclude-drafts --exclude-pre-releases -L 5 --json tagName -q '.[].tagName'); do
        asset=$(gh release view "$tag" -R "$repo" --json assets -q '.assets[].name' | grep '\.dmg$' | head -1)
        [ -n "$asset" ] || continue
        version=${tag#v}
        if [ "$version" != "$have" ]; then
            sha=$(sha_of "https://github.com/$repo/releases/download/$tag/$asset")
            sed -i.bak -E "s|^  version \".*\"|  version \"$version\"|; s|^  sha256 \".*\"|  sha256 \"$sha\"|" "$file"
            rm -f "$file.bak"
            changed="$changed $(basename "$file" .rb)-$version"
        fi
        break
    done
done

echo "${changed# }"
