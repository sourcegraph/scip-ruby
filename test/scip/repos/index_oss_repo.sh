#!/usr/bin/env bash

get_date() {
  date '+%s'
}
PREV_TIME="$(get_date)"
PREV_CMD=""
print_time_elapsed() {
  CUR_TIME="$(get_date)"
  local DELTA=$(( CUR_TIME - PREV_TIME ))
  if [ "$DELTA" -ne 0 ]; then
    echo "Ran in ${DELTA}s: $PREV_CMD\n"
  fi
  PREV_CMD="$BASH_COMMAND"
  PREV_TIME="$CUR_TIME"
}
trap print_time_elapsed DEBUG

if [ "$#" -lt 6 ] || [ "$#" -gt 7 ]; then
  echo "Expected 5-6 arguments: got $#"
  echo "1. Test name"
  echo "2. Clone URL"
  echo "3. git tag to use"
  echo "4. git SHA for double-checking"
  echo "5. Prep command to run before applying the patch"
  echo "6. Command to run for type-checking"
  echo "7. (optional) absolute path to patch to apply"
  exit 1
fi

set -eu

TEST_NAME="$1"
CLONE_URL="$2"
GIT_TAG="$3"
GIT_SHA="$4"
PREP_CMD="$5"
RUN_CMD="$6"
PATCH_ABSPATH=""
TEST_DIR="$PWD"
if [ "$#" -eq 6 ]; then
  PATCH_ABSPATH="$TEST_DIR/$6"
fi

if [ -n "${GITHUB_ACTIONS:-}" ]; then
  echo "::group::$TEST_NAME"
  trap "echo ::end-group::$TEST_NAME" EXIT
fi

rm -rf repo
mkdir repo
pushd repo

git clone "$CLONE_URL" . --branch "$GIT_TAG" --depth=1
if [ "$(git rev-parse HEAD)" -ne "$GIT_SHA" ]; then
  echo "Expected SHA: $GIT_SHA"
  echo "Obtained SHA: $(git rev-parse HEAD)"
  exit 1
fi

eval "$PREP_CMD"

if [ ! -z "$PATCH_ABSPATH" ]; then
  git apply "$PATCH_ABSPATH"
  git diff -U0
fi

eval "$RUN_CMD"

popd
rm -rf repo
