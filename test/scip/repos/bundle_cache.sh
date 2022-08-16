#!/usr/bin/env bash

set -euo pipefail

ENV_VARS=("SCIP_RUBY_CACHE_RUBY_DIR" "RUBY_VERSION_FILE" "PRISTINE_TOOLCHAIN_TGZ_PATH" "OUT_MODIFIED_TOOLCHAIN_TGZ_PATH")
for ENV_VAR in "${ENV_VARS[@]}"; do
  if eval "[ -z \"$(printf '${%s:-}' $ENV_VAR)\" ]"; then
    echo "Missing definition for $ENV_VAR environment variable"
    exit 1
  fi
done

rm -rf "$SCIP_RUBY_CACHE_RUBY_DIR"
mkdir -p "$SCIP_RUBY_CACHE_RUBY_DIR"
tar -xzf "$PRISTINE_TOOLCHAIN_TGZ_PATH" -C "$SCIP_RUBY_CACHE_RUBY_DIR"

SCIP_RUBY_SPECIFIC_RUBY_ROOT="$SCIP_RUBY_CACHE_RUBY_DIR"
if [ -d "$SCIP_RUBY_SPECIFIC_RUBY_ROOT/versions" ]; then
  # rbenv creates an extra versions subdirectory, which doesn't apply in CI.
  # This is to avoid finding the 'gem' from shims/
  SCIP_RUBY_SPECIFIC_RUBY_ROOT="$SCIP_RUBY_SPECIFIC_RUBY_ROOT/versions"
fi
SCIP_RUBY_SPECIFIC_RUBY_ROOT="$SCIP_RUBY_SPECIFIC_RUBY_ROOT/$(< "$RUBY_VERSION_FILE")"

GEM_EXE="$(find "$SCIP_RUBY_SPECIFIC_RUBY_ROOT" -name 'gem' -type f)"
BUNDLE_EXE="$(dirname "$GEM_EXE")/bundle"

compress_deterministic() {
  if [[ "$(tar --version)" == *"GNU"* ]]; then
    tar -czf - -C "$1" . --sort=name --owner=root:0 --group=root:0 --mtime='UTC 1993-05-16'
  else
    (cd "$1" && find . -print0 \
      | sort -z \
      | tar -czf - -T - --no-recursion --null --options='!timestamp')
  fi
}

bundle_cache_single_gem() {
  rm -rf "$TEST_GEM_ZIP_PREFIX"
  unzip -q "$TEST_GEM_ZIP"

  # Is there a more reliable way to get the version? 😬
  _BUNDLER_VERSION="$(tail -n 1 < $TEST_GEM_ZIP_PREFIX/$TEST_GEM_SUBDIR/Gemfile.lock)"
  _BUNDLER_VERSION="${_BUNDLER_VERSION// /}"
  echo "BUNDLER_VERSION = $_BUNDLER_VERSION"
  "$GEM_EXE" install "bundler:$_BUNDLER_VERSION"

  pushd "$TEST_GEM_ZIP_PREFIX/$TEST_GEM_SUBDIR"
  git init -q
  git add .
  GIT_AUTHOR_DATE=1993-05-16T15:04:05Z GIT_COMMITTER_DATE=1993-05-16T15:04:05Z \
    git -c user.name='iu' -c user.email='i@u' commit -a -m '(^_^)' --quiet
  set +e

  # For reasons that are unclear to me, the 'env -' usage works around
  # a gcc problem which manifests as 'cc1' not being executable when invoked
  # as 'gcc blah' and 'ld' not being found when invoked as '/usr/bin/gcc'.
  #
  # This seems specific to some Sorbet configuration; I have not been
  # able to reproduce this weirdness with a minimal configuration outside.
  if ! env - PATH="$PATH" PWD="$PWD" "$BUNDLE_EXE" cache --quiet 2> >(tee stderr.log >&2); then
    err="$(< stderr.log)"
    while IFS= read -r line; do
      if [[ "$line" == *"lib/ruby/gems"*"mkmf.log" ]]; then
        echo "----------- Printing likely bad mkmf.log -----------"
        cat "$line"
        echo "----------------------------------------------------"
      fi
    done <<< "$err"
    exit 1
  fi
  set -e
  git restore .
  popd
  compress_deterministic "$TEST_GEM_ZIP_PREFIX" > "$OUT_GEM_WITH_VENDOR_TGZ_PATH"
}

for arg in "$@"; do
  if [[ "$arg" =~ "zip="(.*)":prefix="(.*)":subdir="(.*)":out="(.*) ]]; then
    TEST_GEM_ZIP="${BASH_REMATCH[1]}"
    TEST_GEM_ZIP_PREFIX="${BASH_REMATCH[2]}"
    TEST_GEM_SUBDIR="${BASH_REMATCH[3]}"
    OUT_GEM_WITH_VENDOR_TGZ_PATH="${BASH_REMATCH[4]}"
    bundle_cache_single_gem
  else
    echo 'error: Bazel-supplied arguments out-of-sync with expected pattern'
    exit 1
  fi
done

compress_deterministic "$SCIP_RUBY_CACHE_RUBY_DIR" > "$OUT_MODIFIED_TOOLCHAIN_TGZ_PATH"