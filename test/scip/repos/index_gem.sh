#!/usr/bin/env bash

set -euo pipefail

# See NOTE[repo-test-structure] for more context.

TEST_DIR="$PWD"
ENV_VARS=("SCIP_RUBY_CACHE_RUBY_DIR" "RUBY_VERSION_FILE" "SCIP_RUBY_GEMS" "CACHED_TGZS" "REPO_NAME" "PATCH_PATH") # "PREP_CMD" "RUN_CMD" )
for ENV_VAR in "${ENV_VARS[@]}"; do
  if eval "[ -z \"$(printf '${%s:-}' $ENV_VAR)\" ]"; then
    echo "Missing definition for $ENV_VAR environment variable"
    exit 1
  fi
done
TEST_NAME="$REPO_NAME"

# TODO: Librarify this, the env var check, and the GITHUB_ACTIONS var and use it consistently.
get_date() {
  date '+%s'
}
PREV_TIME="$(get_date)"
PREV_CMD=""
print_time_elapsed() {
  CUR_TIME="$(get_date)"
  local DELTA=$(( CUR_TIME - PREV_TIME ))
  if [ "$DELTA" -ne 0 ]; then
    echo "---------------------------"
    echo "Ran in ${DELTA}s: $PREV_CMD"
    echo "---------------------------"
  fi
  PREV_CMD="$BASH_COMMAND"
  PREV_TIME="$CUR_TIME"
}
trap print_time_elapsed DEBUG

if [ -n "${GITHUB_ACTIONS:-}" ]; then
  echo "::group::$TEST_NAME"
  trap "echo ::end-group::$TEST_NAME" EXIT
fi

CACHED_TGZS_ARRAY=($CACHED_TGZS)
TGZ_CACHE_DIR="$(dirname ${CACHED_TGZS_ARRAY[0]})"

rm -rf "$SCIP_RUBY_CACHE_RUBY_DIR"
mkdir -p "$SCIP_RUBY_CACHE_RUBY_DIR"
tar -xzf "$TGZ_CACHE_DIR/ruby-post-bundle-cache.tgz" -C "$SCIP_RUBY_CACHE_RUBY_DIR"

rm -rf repo
mkdir repo
tar -xzf "$TGZ_CACHE_DIR/gem-post-vendor.tgz" -C repo

SCIP_RUBY_GEMS_ARRAY=($SCIP_RUBY_GEMS)
for SCIP_RUBY_GEM in "${SCIP_RUBY_GEMS_ARRAY[@]}"; do
  # NOTE: Keep in sync with scip_repos_test.bzl
  if [[ "$SCIP_RUBY_GEM" != *"darwin"* || "$SCIP_RUBY_GEM" == *"20"* ]]; then
    cp "$SCIP_RUBY_GEM" repo/vendor/cache/
  fi
done

SCIP_RUBY_SPECIFIC_RUBY_ROOT="$SCIP_RUBY_CACHE_RUBY_DIR"
if [ -d "$SCIP_RUBY_SPECIFIC_RUBY_ROOT/versions" ]; then
  # rbenv creates an extra versions subdirectory, which doesn't apply in CI.
  # This is to avoid finding the 'gem' from shims/
  SCIP_RUBY_SPECIFIC_RUBY_ROOT="$SCIP_RUBY_SPECIFIC_RUBY_ROOT/versions"
fi
SCIP_RUBY_SPECIFIC_RUBY_ROOT="$SCIP_RUBY_SPECIFIC_RUBY_ROOT/$(< "$RUBY_VERSION_FILE")"

# Little indirect because apparently there may be more bundle binaries inside.
GEM_EXE="$(find "$SCIP_RUBY_SPECIFIC_RUBY_ROOT" -name 'gem' -type f)"
BUNDLE_EXE="$(dirname "$GEM_EXE")/bundle"

pushd repo
git diff --exit-code # No changes should've been made before applying the patch
git apply "../$PATCH_PATH"

"$BUNDLE_EXE" exec 'echo $PATH'
"$BUNDLE_EXE" install -j "$(getconf _NPROCESSORS_ONLN)" --local

set +e
_INFO="$("$BUNDLE_EXE" info scip-ruby-debug)"
if [ $? != 0 ]; then
  set -e
  _INFO="$("$BUNDLE_EXE" info scip-ruby)"
fi
set -e

printf 'bundle info output:\n%s\n' "$_INFO"

# Ideally, we'd write something like:
#
#   "$BUNDLE_EXE" exec scip-ruby --index-file index.scip --gem-metadata "$REPO_NAME@99.99.99" \\
#
# However, there is a discrepancy in paths between bundle install/info
# vs bundle exec (see https://github.com/rubygems/rubygems/issues/5838).
# Work around that by relying on 'bundle info` as the source of truth.
GEM_INSTALL_PATH="$(echo "$_INFO" | grep 'Path:' | sed -e 's/\s*Path: //')"
# From https://stackoverflow.com/a/3352015/2682729
trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    printf '%s' "$var"
}
GEM_INSTALL_PATH="$(trim "$GEM_INSTALL_PATH")"

echo "GEM_INSTALL_PATH = $GEM_INSTALL_PATH"
echo "Calling shim"

{
echo "Shim @ $GEM_INSTALL_PATH/bin/scip-ruby:"
echo "-----------------------------------"
cat "$GEM_INSTALL_PATH/bin/scip-ruby"
echo "-----------------------------------"
echo "This is for debugging/reproduction; I was seeing stale shims earlier, not sure why"
} >&2


# Call the shim, not the native binary, to test that the shim works.
DEBUG=1 "$BUNDLE_EXE" exec "$GEM_INSTALL_PATH/bin/scip-ruby" --index-file index.scip --gem-metadata "$REPO_NAME@99.99.99"
file index.scip

popd