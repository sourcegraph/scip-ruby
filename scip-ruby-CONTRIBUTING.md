# scip-ruby

## Building

```
./bazel build //main:scip-ruby --config=dbg
```

For more information about configurations, see the [Sorbet README](./sorbet-README.md).

<details>
  <summary>Known build issues</summary>

  1. In some Ubuntu instances (Ubuntu 22.04 image on Google Cloud),
      there is a known build error with m4.
      This problem doesn't happen with Ubuntu 20.04.
      ```
      external/m4_v1.4.18/gnulib/lib/c-stack.c:55:26: error: function-like macro 'sysconf' is not defined
      #elif HAVE_LIBSIGSEGV && SIGSTKSZ < 16384
                               ^
      /usr/include/x86_64-linux-gnu/bits/sigstksz.h:28:19: note: expanded from macro 'SIGSTKSZ'
      # define SIGSTKSZ sysconf (_SC_SIGSTKSZ)
                        ^
      external/m4_v1.4.18/gnulib/lib/c-stack.c:139:8: error: fields must have a constant size: 'variable length array in structure' extension will never be   supported
        char buffer[SIGSTKSZ];
               ^
      2 errors generated.
      ```
  2. A release build (`--config=release-mac`) fails on Apple Silicon Macs,
     which (I think) is related to this upstream
     [jemalloc issue](https://github.com/jemalloc/jemalloc/issues/1997),
     which is mentioned to be caused due to a QEMU bug. It manifests as an error:
     ```
     include/jemalloc/internal/rtree.h:118:3: error: constant expression evaluates to -12 which cannot be narrowed to type 'unsigned int' [-Wc++11-narrowing]
        {RTREE_NSB, RTREE_NHIB + RTREE_NSB}
         ^~~~~~~~~
      include/jemalloc/internal/rtree.h:22:19: note: expanded from macro 'RTREE_NSB'
        #define RTREE_NSB (LG_VADDR - RTREE_NLIB)
                  ^~~~~~~~~~~~~~~~~~~~~~~
     ```

</details>

## IDE Integration

Generate `compile_commands.json` as per the [Sorbet README](./sorbet-README.md),
and point your editor to it.

## Generating a SCIP index

NOTE: The binary will be somewhere under `bazel-out` depending on the exact config.

```
scip-ruby myfile.rb --index-file index.scip
```

## Running SCIP tests

Run snapshot tests, which are self-contained:

```
./bazel test //test/scip --config=dbg
```

Updating snapshots:

```
./bazel test //test/scip:update --config=dbg
```

Run repo tests, to check that there are no crashes on indexing OSS repos:

```
# If Ruby was installed via asdf (recommended to avoid dependency on system Ruby on macOS)
./bazel test --test_env GEM_PATH="$HOME/.asdf/installs/ruby/2.7.2/bin" //test/scip/repos --config=dbg

# Otherwise, I think this might work.
./bazel test --test_env GEM_PATH="$(dirname "$(which gem)")" //test/scip/repos --config=dbg
```

This may take a few minutes to run.

<details>
  <summary>Known testing issues</summary>

  1. On macOS, Ruby 2.7.x may fail to install due to a combination of `-Werror`
     and a warning in OpenSSL. As a workaround, you can use the following asdf invocation:
     ```
     OPENSSL_CFLAGS=-Wno-error=implicit-function-declaration asdf install ruby 2.7.2
     ```
     This works with 2.7.2, but not with 2.7.0.
</details>

## Writing a new snapshot test

See the existings tests under `test/scip/testdata`
and copy the structure. One caveat is that the first time
you add a new test, you should create matching `.snapshot.rb` files
(which may be empty) for all new `.rb` files,
since those are used as inputs to Bazel.
If you know of a way to get rid of that annoyance, submit a PR.

## Writing a new repo test

First, clone the repo using Sorbet locally
and check if you can index it.
Typically, the commands will be something like:

```
BUNDLE_WITH=sorbet bundle install

# Replace srb binary with scip-ruby binary
cp /path/to/scip-ruby "$(find . -name 'srb' -type f | head -n 1)"
bundle exec srb --index-file index.scip --gem-metadata "name@version"
```

In case there are any type errors, create a patch and save it:
```
git diff > /path/to/test/scip/repos/name-version.patch
```

Once you're able to successfully index the code,
modify the [scip_repos_test.bzl](test/scip/repos/scip_repos_test.bzl)
file to include the relevant data.

## Debugging with print statements

So far, I've mostly been using print debugging
(along with minimized test cases)
since I find it more helpful to see a bunch of output
along with the control flow graph all at once.

Typically, I'll copy over the minimized code
to the root and run:

```
./bazel build //main:scip-ruby --config=dbg && ./bazel-out/darwin-dbg/bin/main/scip-ruby tmp.rb -p cfg-text --index-file /dev/null
```

Alternately, it may be useful to create a `tmp.rb`
file under the `test/scip/snapshots/` directory
(it will be gitignored) and run:

```
# Check
./bazel test //test/scip:tmp --config=dbg
# View output
./bazel test //test/scip:update_tmp --config=dbg && cat test/scip/testdata/tmp.snapshot.rb
```

Having the [SCIP CLI](https://github.com/sourcegraph/scip) available
is also useful for inspecting the emitted index.

## Debugging with LLDB

Maybe there is a cleaner way to do this,
but the following works:

```
export TEST_DIR="$PWD/test/scip/testdata"
pushd bazel-out/darwin-dbg/bin
lldb -- ./test/scip_test_runner "$TEST_DIR/my_test.rb" --output="$TEST_DIR/my_test.snapshot.rb"
popd
unset TEST_DIR
```

## Creating PRs

PRs created through the GitHub UI default to being made
against the upstream Sorbet repo. It is less error-prone
to use the [GitHub CLI](https://cli.github.com/) instead.

```
gh pr create -R sourcegraph/scip-ruby
```

This will correctly use the `scip-ruby/master` branch as the target.

## Cutting a release

Push a tag matching `scip-ruby-v*` to `scip-ruby/master`.
A CI job should automatically trigger a release.
See the [release workflow](/.github/workflows/release.yml) for details.
