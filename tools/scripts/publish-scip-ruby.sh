#!/usr/bin/env bash

set -euo pipefail

{

if [ -z "${NEW_VERSION:-}" ]; then
  echo "error: Missing value for environment variable NEW_VERSION"
  echo "hint: Invoke this script as NEW_VERSION=M.N.P ./tools/scripts/publish-scip-ruby.sh"
  exit 1
fi

if ! grep -q "## v$NEW_VERSION" CHANGELOG.md; then
  echo "error: Missing CHANGELOG entry for v$NEW_VERSION"
  echo "note: CHANGELOG entries are required for publishing releases"
  exit 1
fi

if ! grep -q "const char scip_ruby_version\[\] = \"$NEW_VERSION\"" scip_indexer/SCIPIndexer.cc; then
  echo "error: SCIP_RUBY_VERSION in SCIPIndexer.cc doesn't match NEW_VERSION=$NEW_VERSION"
  exit 1
fi

if ! grep -q "download/scip-ruby-$NEW_VERSION" Dockerfile.autoindex; then
  echo "error: scip-ruby version in Dockerfile is not the latest release version."
  exit 1
fi

if ! git diff --quiet; then
  echo "error: Found unstaged changes; aborting."
  exit 1
fi

if ! git diff --quiet --cached; then
  echo "error: Found staged-but-uncommitted changes; aborting."
  exit 1
fi

if ! git remote -v | grep "origin" | grep -q "https://github.com/sourcegraph/scip-ruby.git"; then
  echo "error: remote 'origin' doesn't point to sourcegraph/scip-ruby"
  exit 1
fi

if ! git rev-parse --abbrev-ref HEAD | grep -q "scip-ruby/master"; then
  echo "error: Releases should be published from scip-ruby/master but HEAD is on a different branch" >&2
  exit 1
fi

} >&2

TAG="scip-ruby-v$NEW_VERSION"
git tag "$TAG"
git push origin "$TAG"
