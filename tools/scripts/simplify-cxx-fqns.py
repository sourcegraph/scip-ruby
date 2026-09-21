#!/usr/bin/env python3

# Utility script to simplify fully-qualified symbol names in C++ stack traces.

import logging
import pathlib
import os
import subprocess as sp
import sys

# Why use comby instead of sed or backtracking regexes?
#
# 1. Comby handles < > balancing.
# 2. Comby takes care of whitespace automatically.
# 3. Comby patterns are quite readable

def simplify(input: bytes) -> bytes:
  config_path = pathlib.Path(__file__).parent.joinpath('comby-rewrites.toml')
  invocation = ['comby', '-lang', '.c', '-stdin', '-stdout', '-templates', str(config_path)]
  comby_ret = sp.run(invocation, input=input, capture_output=True)
  comby_ret.check_returncode()
  return comby_ret.stdout

def simplify_until_fixpoint(input: bytes) -> bytes:
  output = simplify(input)
  if output == input:
    return output
  return simplify_until_fixpoint(output)

def default_main():
  if sp.run(['comby', '--help'], stdout=sp.DEVNULL, stderr=sp.PIPE).returncode != 0:
    logging.error('comby --help failed; is comby missing?')
    sys.exit(1)

  if len(sys.argv) > 1 and sys.argv[1] == '--help':
    print('Usage: ./my-binary <args> 2> >(./tools/scripts/simplify-cxx-fqns.py)')
    return

  input = sys.stdin.buffer.read()
  output = simplify_until_fixpoint(input)
  sys.stdout.buffer.write(output)

if __name__ == '__main__':
  default_main()
