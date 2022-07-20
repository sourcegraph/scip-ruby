#!/bin/bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../.."
# we are now at the repo root.

./bazel build \
  //gems/sorbet/test/snapshot:update \
  //test/cli:update //test/lsp:update \
  -c opt "$@"

tools/scripts/update_testdata_exp.sh
gems/sorbet/test/hidden-method-finder/update_hidden_methods_exp.sh "$@"

./bazel test \
  //gems/sorbet/test/snapshot:update \
  //gems/sorbet-runtime:update_call_validation \
  //test/cli:update //test/lsp:update //test/scip:update -c opt "$@"

tools/scripts/update_testdata_exp.sh
test/cli/update_cli_exp_files.sh
