#!/usr/bin/env bash

set -euo pipefail

# Count available CPUs so compiling Ruby can use the machine efficiently.
# Remove after https://github.com/rbenv/ruby-build/issues/2024 is fixed.
NUM_CPUS="$(getconf _NPROCESSORS_ONLN)"

# Make sure the caller supplied every path and tool this script needs.
ENV_VARS=("SCIP_RUBY_CACHE_RUBY_DIR" "SCIP_RUBY_RBENV_EXE" "RUBY_VERSION_FILE" "OUT_TGZ_PATH" "NUM_CPUS")
for ENV_VAR in "${ENV_VARS[@]}"; do
  if eval "[ -z \"$(printf '${%s:-}' $ENV_VAR)\" ]"; then
    echo "Missing definition for $ENV_VAR environment variable"
    exit 1
  fi
done

# Tell Ruby's build process how many parallel jobs it can run.
export MAKE_OPTS="-j ${NUM_CPUS:-4}"

# Create the cache directory before installing Ruby or reading an existing copy.
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

  # Install the requested Ruby version unless it is already present in the cache.
  RBENV_ROOT="$SCIP_RUBY_CACHE_RUBY_DIR" "$SCIP_RUBY_RBENV_EXE" install --skip-existing
fi

# Write a gzip archive with stable file order and metadata. That makes the
# output repeatable when the input files are the same.
compress_deterministic() {
  if [[ "$(tar --version)" == *"GNU"* ]]; then
    tar -czf - -C "$1" . --sort=name --owner=root:0 --group=root:0 --mtime='UTC 1993-05-16'
  else
    (cd "$1" && find . -print0 \
      | sort -z \
      | tar -czf - -T - --no-recursion --null --options='!timestamp')
  fi
}

# Ensure the output directory exists and remove any stale archive at the target
# path before writing the new one.
mkdir -p "$(dirname "$OUT_TGZ_PATH")"
rm -f "$OUT_TGZ_PATH"

# Read the Ruby version this archive should contain.
ruby_version="$(< "$RUBY_VERSION_FILE")"

# This will be set to the directory that contains the Ruby executable and its
# supporting files.
ruby_install_root=""

# Prefer the directory shape produced by local Ruby installs.
if [[ -x "$SCIP_RUBY_CACHE_RUBY_DIR/versions/$ruby_version/bin/ruby" ]]; then
  ruby_install_root="$SCIP_RUBY_CACHE_RUBY_DIR/versions/$ruby_version"
elif [[ -d "$SCIP_RUBY_CACHE_RUBY_DIR/$ruby_version" ]]; then
  # Some preinstalled Rubies put the files one directory deeper. Find the one
  # child directory that actually contains a Ruby executable.
  ruby_install_roots=()
  for candidate in "$SCIP_RUBY_CACHE_RUBY_DIR/$ruby_version"/*; do
    if [[ -x "$candidate/bin/ruby" ]]; then
      ruby_install_roots+=("$candidate")
    fi
  done
  if [[ ${#ruby_install_roots[@]} -eq 1 ]]; then
    ruby_install_root="${ruby_install_roots[0]}"
  fi
fi

# Stop with a clear message if the cache does not contain the requested Ruby.
if [[ -z "$ruby_install_root" ]]; then
  echo "Could not find Ruby $ruby_version under $SCIP_RUBY_CACHE_RUBY_DIR"
  exit 1
fi

# Copy the selected Ruby install into a temporary directory with one predictable
# layout. Consumers of this archive can then always look in versions/<version>.
normalized_root="$(mktemp -d)"
trap 'rm -rf "$normalized_root"' EXIT
mkdir -p "$normalized_root/versions"
cp -a "$ruby_install_root" "$normalized_root/versions/$ruby_version"

# Compress the normalized directory into the requested output archive.
compress_deterministic "$normalized_root" > "$OUT_TGZ_PATH"
