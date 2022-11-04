# Working on scip-ruby

This document covers the day-to-day aspects of `scip-ruby`.
For questions on why certain things are the way they are,
see the [Design Decisions doc][].

[Design Decisions doc]: DESIGN.md

- [Install dependencies](#install-dependencies)
- [Configuring Ruby (optional)](#configuring-ruby-optional)
- [Building](#building)
  - [Building gems](#building-gems)
- [IDE integration](#ide-integration)
- [Generating a SCIP index](#generating-a-scip-index)
- [Testing](#testing)
  - [Running tests](#running-tests)
  - [Writing tests](#writing-tests)
    - [Writing a new snapshot test](#writing-a-new-snapshot-test)
    - [Writing a new repo test](#writing-a-new-snapshot-test)
- [Debugging](#debugging)
  - [More readable stack traces](#more-readable-stack-traces)
  - [Debugging with print statements](#debugging-with-print-statements)
  - [Debugging with LLDB](#debugging-with-lldb)
  - [Debugging build issues](#debugging-build-issues)
    - [Debugging Bazel](#debugging-bazel)
    - [Debugging on Linux](#debugging-on-linux)
- [Creating PRs](#creating-prs)
- [Syncing Sorbet upstream](#syncing-sorbet-upstream)
- [Cutting a release](#cutting-a-release)
- Troubleshooting
  - [Known build issues][]
  - [Known RubyGems related issues](#known-rubygems-related-issues)
  - [Known testing issues](#known-testing-issues)

[Known build issues]: #known-build-issues

## Install dependencies

1. C++ toolchain (gcc or clang): Used for bootstrapping.
2. [rbenv][]: (optional) This is used for [Configuring Ruby](#configuring-ruby-optional).

[rbenv]: https://github.com/rbenv/rbenv#installation

## Configuring Ruby (optional)

If you're going to be running the repository tests or building the
scip-ruby gem locally, follow these steps before building stuff.

### macOS pre-requisites

arm64 macOS builds aren't supported yet,
so it is simpler to have a consistent set of tools
where Homebrew is running under Rosetta too.

```
mkdir ~/.homebrew-x86_64
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ~/.homebrew-x86_64
./xbrew --version # check that it works
```

**WARNING:** Do not put this `brew` on your PATH!
That may lead to confusing errors when working on other projects.

### rbenv setup

#### Linux

Install [rbenv][] as per the official instructions. For `ruby-build`,
do NOT install it as a plugin.

<details>
<summary>Why not install `ruby-build` as a plugin?</summary>

The `RBENV_ROOT` variable does double-duty;
it serves as the location to install the tools, and it is also used to
locate plugins (like `ruby-build` -- if you install it as a plugin).
However, in our case, since we are using a different tool path,
`rbenv` will be unable to use the `install` plugin.

To mimic the configuration on macOS, I recommend
installing `ruby-build` next to the `rbenv` binary.
</details>

```
git clone https://github.com/rbenv/ruby-build.git --depth=1
# Assuming you installed rbenv through git as is recommended in the README.
PREFIX="$HOME/.rbenv" ./ruby-build/install.sh
rm -rf ruby-build
```

```bash
# Set up a global installation because that helps parallelize the build.
rbenv install
echo "build --define SCIP_RUBY_CACHE_RUBY_DIR='$PWD/.cache_ruby' --define SCIP_RUBY_RBENV_EXE='$(which rbenv)' --define EXTERNAL_GEM_EXE='$(which gem)'" >> .bazelrc.local
```

#### macOS

```bash
./xbrew install rbenv
echo "build --define SCIP_RUBY_CACHE_RUBY_DIR='$PWD/.cache_ruby' --define SCIP_RUBY_RBENV_EXE='$(./xbrew where rbenv)' --define EXTERNAL_GEM_EXE=/usr/bin/gem" >> .bazelrc.local
```

If you're wondering why we have this separate kind of caching,
instead of having everything happen through the Magic of Bazel (TM),
see the [Design Decisions doc][].

## Building

```
# Optionally replace 'dbg' with 'release-linux' or 'release-mac'
./bazel build //main:scip-ruby --config=dbg
```

The generated binary is located at `./bazel-bin/main/scip-ruby`.

For more information about configurations, see the [Sorbet README](./sorbet-README.md). If you run into a build issue, check if it matches one of the [Known build issues][]; you may need to change your configuration.

### Building gems

```bash
./bazel build //gems/scip-ruby --config=dbg
```

The generated gems are located in `./bazel-bin/gems/scip-ruby`.
For testing in local builds and CI, the gems use a hard-coded version `1993.5.16`.
To build a different version, pass `--//gem/scip-ruby:version=M.N.P`.

## IDE Integration

Generate `compile_commands.json` as per the [Sorbet README](./sorbet-README.md),
and point your editor to it. In case you see an error in VS Code saying that
`clangd` could not be found at a path under `bazel-sorbet/`, create a symlink:

```bash
ln -s bazel-scip-ruby bazel-sorbet
```

## Generating a SCIP index

NOTE: The binary will be somewhere under `bazel-out` depending on the exact config.

```
scip-ruby myfile.rb --index-file index.scip
```

## Testing

### Running tests

There are currently 3 kinds of tests:
- Snapshot tests: These cover indexer output.
- Unit tests: These cover some internals which are not possible
  to test via snapshots.
- Repo/Integration tests: These try to index an OSS repo using scip-ruby.

Here are some example test invocations:

```
# Run both snapshot tests and unit tests
./bazel test --config=dbg //test/scip

# Run only unit tests
./bazel test --config=dbg //test/scip:unit_tests

# Run a specific snapshot test, e.g. 'testdata/alias.rb'
./bazel test --config=dbg //test/scip:alias
```

You can add `--test_output=errors` to see diffs for snapshot mismatches.

Snapshot outputs can be easily updated:

```
# Update all snapshots
./bazel test --config=dbg //test/scip:update

# Update snapshot for a single test
./bazel test --config=dbg //test/scip:update_alias
```

Repo tests are kinda' broken right now; they're disabled
in CI (see ci.yml), and may or may not work on your machine.

If you want to run repo tests, first complete the
[Configuring Ruby](#configuring-ruby-optional) steps.
Then run the tests using:

```bash
# If Ruby was installed via asdf (recommended to avoid dependency on system Ruby on macOS)
./bazel test //test/scip/repos --config=dbg
```

This may take a few minutes to run.

### Writing a new snapshot test

See the existings tests under `test/scip/testdata`
and copy the structure. One caveat is that the first time
you add a new test, you should create matching `.snapshot.rb` files
(which may be empty) for all new `.rb` files,
since those are used as inputs to Bazel.
If you know of a way to get rid of that annoyance, submit a PR.

### Writing a new unit test

See the existing unit tests in `scip_test_runner.cc`
and follow the same structure.

### Writing a new repo test

First, clone the repo using Sorbet locally
and check if you can index it.
Typically, the commands will be something like:

```bash
BUNDLE_WITH=sorbet bundle install

# Replace srb binary with scip-ruby binary
cp /path/to/scip-ruby "$(find . -name 'srb' -type f | head -n 1)"
bundle exec srb --index-file index.scip --gem-metadata "name@version"
```

In case there are any type errors, create a patch and save it:
```bash
git diff > /path/to/test/scip/repos/name-version.patch
```

Once you're able to successfully index the code,
modify the [scip_repos_test.bzl](test/scip/repos/scip_repos_test.bzl)
file to include the relevant data.

## Debugging

### More readable stack traces

C++ stack traces can get pretty gnarly with text like:

```c++
std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char> >
```

instead of `std::string`.

If you have a stack trace, run it through the simplification script.

```
./bazel-bin/main/scip-ruby <args> 2> >(./tools/scripts/simplify-cxx-fqns.py)
```

NOTE: The script requires [Comby](https://comby.dev/docs/get-started#install).

### Debugging with print statements

So far, I've mostly been using print debugging
(along with minimized test cases)
since I find it more helpful to see a bunch of output
along with the control flow graph all at once.

Typically, I'll copy over the minimized code
to the root and run:

```bash
./bazel build //main:scip-ruby --config=dbg && ./bazel-out/darwin-dbg/bin/main/scip-ruby tmp.rb -p cfg-text-loc --index-file /dev/null
```

Alternately, it may be useful to create a `tmp.rb`
file under the `test/scip/testdata/` directory
(it will be gitignored) and run:

```bash
# Check
./bazel test //test/scip:tmp --config=dbg
# View output
./bazel test //test/scip:update_tmp --config=dbg && cat test/scip/testdata/tmp.snapshot.rb
```

Having the [SCIP CLI](https://github.com/sourcegraph/scip) available
is also useful for inspecting the emitted index.

### Debugging with LLDB

Maybe there is a cleaner way to do this,
but the following works:

```bash
export TEST_DIR="$PWD/test/scip/testdata"
pushd bazel-out/darwin-dbg/bin
lldb -- ./test/scip_test_runner "$TEST_DIR/my_test.rb" --output="$TEST_DIR/my_test.snapshot.rb"
popd
unset TEST_DIR
```

### Debugging build issues

#### Debugging Bazel

See Keith Smiley's blog post [Debugging bazel actions](https://www.smileykeith.com/2022/03/02/debugging-bazel-actions/). ([archive link](https://web.archive.org/web/20220711000725/https://www.smileykeith.com/2022/03/02/debugging-bazel-actions/))

One KEY thing to keep in mind is that some problems only manifest
inside the sandbox but not outside because Bazel sandbox changes
the binaries available at certain paths to use non-system tools.

For example, `uname -m` on an M1 Mac would normally return `arm64`
but inside an x86_64 Bazel environment (currently the default)
it will return `x86_64`.

For compiler issues inside a sandbox,
it helpful to test a small code snippet first.

```bash
{
  echo '--- Try compiling some simple stuff ---'
  {
    echo '#include <stdio.h>'
    echo ''
    echo 'int main() {'
    echo '  printf("Hello %s\n", "World!");'
    echo '  return 0;'
    echo '}'
  } > tmp.c
  gcc tmp.c
  ./a.out
  rm tmp.c ./a.out
  echo '--------------------------------------'
} >&2
```

#### Debugging on Linux

Debugging a build issue in GitHub Actions can get emotionally draining quickly.

If you work at Sourcegraph, set up a GCP VM.
You may find the companion [VM setup script](./vm_setup.sh) helpful.
It is not tested in CI, so you may need to tweak it a bit.

Don't forget to delete the instance after you're done investigating!

## Creating PRs

PRs created through the GitHub UI default to being made
against the upstream Sorbet repo. It is less error-prone
to use the [GitHub CLI](https://cli.github.com/) instead.

```bash
gh pr create -R sourcegraph/scip-ruby
```

This will correctly use the `scip-ruby/master` branch as the target.

## Syncing Sorbet upstream

1. Create a temporary branch and perform a merge. It doesn't matter
   if the code compiles or not, only try to fix conflicts reasonably.
   Do NOT modify existing commits/rewrite history here.
2. Create a new commit updating the `scip_ruby_sync_upstream_sorbet_sha` value.
3. If there are compilation/test failures, fix them in a single follow-up commit.
   In total, we will have N+1 or N+2 commits in the PR, with N from Sorbet.
4. Once tests are passing, temporarily turn on 'Allow merge commits' in the admin settings.
   Merge the PR and turn off merging in the admin settings.

## Cutting a release

1. Add release notes to the [CHANGELOG](/CHANGELOG.md).
2. Bump `scip_ruby_version` in `SCIPIndexer.cc`.

Run the release script:

```bash
NEW_VERSION=M.N.P ./tools/scripts/publish-scip-ruby.sh
```

If there are any errors, fix those and re-run.
A CI job will be kicked off to trigger a release.
See the [release workflow](/.github/workflows/release.yml) for details.

## Troubleshooting

### Known build issues

1. On some Ubuntu instances (Ubuntu 22.04 image on Google Cloud),
    there is a known build error with m4.
    This problem doesn't happen with Ubuntu 20.04.
    ```txt
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
   ```txt
   include/jemalloc/internal/rtree.h:118:3: error: constant expression evaluates to -12 which cannot be narrowed to type 'unsigned int' [-Wc++11-narrowing]
      {RTREE_NSB, RTREE_NHIB + RTREE_NSB}
       ^~~~~~~~~
    include/jemalloc/internal/rtree.h:22:19: note: expanded from macro 'RTREE_NSB'
      #define RTREE_NSB (LG_VADDR - RTREE_NLIB)
                ^~~~~~~~~~~~~~~~~~~~~~~
   ```
3. Using Xcode 14 can trigger a build error inside the C++ toolchain config.
   ```text
   File "/private/var/tmp/_bazel_xyz/0eec049f96822615c65f9acc22fdf113/external/local_config_cc/cc_toolchain_config.bzl", line 45, column 25, in _can_use_deterministic_libtool
           if _compare_versions(xcode_version, _SUPPORTS_DETERMINISTIC_MODE) >= 0:
   File "/private/var/tmp/_bazel_xyz/0eec049f96822615c65f9acc22fdf113/external/local_config_cc/cc_toolchain_config.bzl", line 38, column 15, in _compare_versions
           return dv1.compare_to(apple_common.dotted_version(v2))
   Error: 'NoneType' value has no field or method 'compare_to'
   ```
   Downgrading to Xcode 13.4 fixes the issue.
   Older Xcode versions can be downloaded from developer.apple.com
   (requires logging in; a free account is fine).
   It is a bit difficult to find in the UI,
   so you may want to click on one of the 'Download' links on
   the [xcodereleases.com](https://xcodereleases.com/) page.

### Known RubyGems related issues

1. If you're trying to run `bundle install` for a gem
   which you're trying to test,
   you may run into an error which looks like:
   ```txt
   Could not fetch specs from https://rubygems.org/
   ```
   despite retrying a few times, with not much more information.

   According to [this StackOverflow Q&A](https://stackoverflow.com/questions/15194481/bundle-install-could-not-fetch-specs-from-https-rubygems-org),
   the problem is due to an IPv6 issue with RubyGems.
   (IIUC, it is somewhat flaky, not totally unsupported.)

   On macOS, you can change this in your Wi-Fi settings:
   Network Preferences > Advanced > TCP/IP >
   Configure IPv6: set to Link-local only.
   You need to Apply the settings after changing that field.

### Known testing issues

I can't quite figure out why, but with some of the custom rules,
the executable script being modified doesn't trigger a rebuild.
If you're seeing stale results, try something like:

```bash
rm -rf .cache_ruby/ && (cd bazel-bin && find . -name '*.tgz' -type f -delete)
```
