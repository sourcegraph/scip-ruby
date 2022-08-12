#!/usr/bin/env bash

set -euo pipefail

CACHE_ROOT="$HOME/bazelcache"
mkdir -p "$CACHE_ROOT/output-base" "$CACHE_ROOT/build" "$CACHE_ROOT/repos"
{
  echo 'common --curses=no --color=yes'
  echo "startup --output_base=$CACHE_ROOT/output-base"
  echo "build  --disk_cache=$CACHE_ROOT/build --repository_cache=$CACHE_ROOT/repos"
  if [ -n "${VERSION:-}" ]; then
    echo "build --//gems/scip-ruby:version=$VERSION"
  fi
  echo "test   --disk_cache=$CACHE_ROOT/build --repository_cache=$CACHE_ROOT/repos --test_output=errors"
} > .bazelrc.local

# Install Bazel and print version
./bazel version
