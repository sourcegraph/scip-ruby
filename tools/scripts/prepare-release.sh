#!/usr/bin/env bash

# Bumps scip_ruby_version in SCIPIndexer.cc and adds an editable CHANGELOG entry
# for a Docker image rebuild.
#
# Inputs:
# NEW_VERSION (optional) should be a string M.N.P. Defaults to the
# next patch version after the latest release tag.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

LAST_TAG="$(git describe --tags --abbrev=0 --match 'scip-ruby-v[0-9]*')"
LAST_VERSION="${LAST_TAG#scip-ruby-v}"
IFS=. read -r MAJOR MINOR PATCH <<<"$LAST_VERSION"
NEW_VERSION="${NEW_VERSION:-$MAJOR.$MINOR.$((PATCH + 1))}"

if ! [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "error: NEW_VERSION=$NEW_VERSION is not of the form M.N.P"
  exit 1
fi
if [ "$NEW_VERSION" = "$LAST_VERSION" ] ||
  [ "$(printf '%s\n%s\n' "$LAST_VERSION" "$NEW_VERSION" | sort -V | tail -n 1)" != "$NEW_VERSION" ]; then
  echo "error: NEW_VERSION=$NEW_VERSION must be newer than the latest release $LAST_TAG"
  exit 1
fi

TAG="scip-ruby-v$NEW_VERSION"
awk -v version="v$NEW_VERSION" -v tag="$TAG" '
  !inserted && /^## v/ {
    print "## " version "\n"
    print "Rebuilds the Docker images with the latest Debian package updates.\n"
    print "[Full release notes](https://github.com/sourcegraph/scip-ruby/releases/tag/" tag ")\n"
    inserted = 1
  }
  { print }
' CHANGELOG.md >CHANGELOG.md.new
mv CHANGELOG.md.new CHANGELOG.md

SCIP_INDEXER=scip_indexer/SCIPIndexer.cc
sed -E "s|^const char scip_ruby_version\[\] = \".*\";|const char scip_ruby_version[] = \"$NEW_VERSION\";|" "$SCIP_INDEXER" >"$SCIP_INDEXER.new"
mv "$SCIP_INDEXER.new" "$SCIP_INDEXER"

if ! grep -q "^const char scip_ruby_version\[\] = \"$NEW_VERSION\";" "$SCIP_INDEXER"; then
  echo "error: Failed to update scip_ruby_version in $SCIP_INDEXER"
  exit 1
fi
echo "Prepared release $TAG"
