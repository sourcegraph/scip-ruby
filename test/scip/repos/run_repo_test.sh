#!/usr/bin/env bash

set -euo pipefail

required_env=("GEM_METADATA" "INDEX_ARGS" "PROJECT_SUBDIR" "REPO_ARCHIVE" "REPO_NAME" "SCIP_RUBY" "STRIP_PREFIX")
for env_var in "${required_env[@]}"; do
  if [[ -z "${!env_var:-}" ]]; then
    echo "Missing definition for $env_var environment variable"
    exit 1
  fi
done

abspath() {
  local path="$1"
  if [[ "$path" = /* ]]; then
    printf '%s\n' "$path"
  else
    printf '%s/%s\n' "$PWD" "$path"
  fi
}

REPO_ARCHIVE="$(abspath "$REPO_ARCHIVE")"
SCIP_RUBY="$(abspath "$SCIP_RUBY")"
export SORBET_SILENCE_DEV_MESSAGE=1
if [[ -n "${LLVM_LIBUNWIND:-}" ]]; then
  LLVM_LIBUNWIND="$(abspath "$LLVM_LIBUNWIND")"
  export DYLD_LIBRARY_PATH="$(dirname "$LLVM_LIBUNWIND"):${DYLD_LIBRARY_PATH:-}"
fi

workdir="${TEST_TMPDIR:-$(mktemp -d)}/scip-ruby-repo-test/$REPO_NAME"
rm -rf "$workdir"
mkdir -p "$workdir/unpack"

echo "Unpacking $REPO_NAME from $REPO_ARCHIVE"
# Use Python instead of `unzip` because some real-world archives contain
# filenames that the macOS `unzip` command handles poorly.
python3 - "$REPO_ARCHIVE" "$workdir/unpack" <<'PY'
import sys
import zipfile

archive, destination = sys.argv[1:]
with zipfile.ZipFile(archive) as zf:
    zf.extractall(destination)
PY

repo_root="$workdir/unpack/$STRIP_PREFIX"
if [[ "$PROJECT_SUBDIR" != "." ]]; then
  repo_root="$repo_root/$PROJECT_SUBDIR"
fi

if [[ ! -d "$repo_root" ]]; then
  echo "Could not find repo root: $repo_root"
  echo "Unpacked directories:"
  find "$workdir/unpack" -maxdepth 2 -type d | sort
  exit 1
fi

index_file="$workdir/index.scip"

echo "Running scip-ruby for $REPO_NAME"
(
  cd "$repo_root"
  read -r -a index_args <<< "$INDEX_ARGS"
  "$SCIP_RUBY" --index-file "$index_file" --gem-metadata "$GEM_METADATA" "${index_args[@]}"
)

if [[ ! -s "$index_file" ]]; then
  echo "Expected scip-ruby to create a non-empty index at $index_file"
  exit 1
fi

index_size="$(wc -c < "$index_file")"
echo "Created non-empty SCIP index at $index_file ($index_size bytes)"
