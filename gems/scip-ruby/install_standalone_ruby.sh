#!/usr/bin/env bash

set -euo pipefail

# Remove after https://github.com/rbenv/ruby-build/issues/2024 is fixed.
NUM_CPUS="$(getconf _NPROCESSORS_ONLN)"
ENV_VARS=("SCIP_RUBY_CACHE_RUBY_DIR" "SCIP_RUBY_RBENV_EXE" "RUBY_VERSION_FILE" "OUT_TGZ_PATH" "NUM_CPUS")
for ENV_VAR in "${ENV_VARS[@]}"; do
  if eval "[ -z \"$(printf '${%s:-}' $ENV_VAR)\" ]"; then
    echo "Missing definition for $ENV_VAR environment variable"
    exit 1
  fi
done
export MAKE_OPTS="-j ${NUM_CPUS:-4}"

mkdir -p "$SCIP_RUBY_CACHE_RUBY_DIR"

# Debugging tip: If there is a failure in this step, replace it with:
#
#   CC="$SCIP_RUBY_CACHE_RUBY_DIR/cc_wrapper" "$SCIP_RUBY_RBENV_EXE" install --keep --force
#
# In cc_wrapper, add the following:
#
#   #!/usr/bin/env bash
#   echo "cc $*" >> "$(dirname "${BASH_SOURCE[0]}")/cc.log"
#   exec cc "$@"
#
# This will persist the build directory and record invocations which
# can be replayed for faster triage.

if [[ "$SCIP_RUBY_RBENV_EXE" != "RUNNING_IN_CI_RBENV_NOT_NEEDED" ]]; then
  # Make ruby-build available to rbenv.
  export PATH="$(dirname "$SCIP_RUBY_RBENV_EXE"):$PATH"
  RBENV_ROOT="$SCIP_RUBY_CACHE_RUBY_DIR" "$SCIP_RUBY_RBENV_EXE" install --skip-existing
fi

compress_deterministic() {
  if [[ "$(tar --version)" == *"GNU"* ]]; then
    tar -czf - -C "$1" . --sort=name --owner=root:0 --group=root:0 --mtime='UTC 1993-05-16'
  else
    (cd "$1" && find . -print0 \
      | sort -z \
      | tar -czf - -T - --no-recursion --null --options='!timestamp')
  fi
}

mkdir -p "$(dirname "$OUT_TGZ_PATH")"
rm -f "$OUT_TGZ_PATH"

compress_deterministic "$SCIP_RUBY_CACHE_RUBY_DIR" > "$OUT_TGZ_PATH"