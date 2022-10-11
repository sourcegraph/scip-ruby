# scip-ruby

Experimental [SCIP](https://github.com/sourcegraph/scip) indexer for Ruby,
enabling precise code navigation for Ruby —
Go to definition, Find references, hover docs etc. –
in Sourcegraph.

![Example showing cross-file Find references for a type from the shopify-api-ruby codebase](https://user-images.githubusercontent.com/93103176/194205214-2e2d64da-d02c-4ab3-8636-2497e4d46628.png)

If you have any questions, bug reports, feature requests or feedback,
please [file an issue](https://github.com/sourcegraph/scip-ruby/issues/new/choose).

## Supported Configurations

scip-ruby builds on top of
the [Sorbet](https://github.com/sorbet/sorbet) type-checker.
It is primarily meant for use in projects which have started adopting Sorbet.
Higher Sorbet adoption (`# typed: true` or higher) is likely to lead to
a better code navigation experience.
However, scip-ruby can also index `# typed: false` files on a best-effort basis.
Like Sorbet, scip-ruby treats files without a `# typed:` sigil
as implicitly being `# typed: false`.

Currently, we have gems and binaries available for x86\_64 Linux and x86\_64 macOS (supported on arm64 macOS via Rosetta).

## Quick Start

This section covers the easiest way to use `scip-ruby`: as a gem,
which includes a platform-specific `scip-ruby` binary
and uses that for indexing.
Alternately, you can
[directly download a binary and index your code](#download-binary-and-index).

### First-time setup

If you have a `.gemspec` file, use `add_development_dependency`:

```ruby
Gem::Specification.new do |spec|
  # ... other stuff ...
  spec.add_development_dependency("scip-ruby")
end
```

Otherwise, add this line to your `Gemfile`:

```ruby
gem 'scip-ruby', require: false, :group => :development
```
After either of those steps, run `bundle install`
to download and install fetch `scip-ruby`.

### Generate an index

Run `scip-ruby` along with some information about your gem.

<!-- TODO: Add support for defaulting. -->

- If you have a `sorbet/config` file, that will be picked up
  automatically to determine which files to index.
    ```bash
    # Uses the latest revision as the version - prefer this if you will index every commit
    bundle exec scip-ruby --index-file index.scip --gem-metadata "my-gem-name@$(git rev-parse HEAD)"

    # Uses the latest tag as the version - prefer this if you're only indexing specific tags
    bundle exec scip-ruby --index-file index.scip --gem-metadata "my-gem-name@$(git describe --tags --abbrev=0)"
    ```
- If you don't have a `sorbet/config` file, add an extra path argument
  to index all files in the project.
    ```bash
    # Uses the latest revision as the version - prefer this if you will index every commit
    bundle exec scip-ruby . --index-file index.scip --gem-metadata "my-gem-name@$(git rev-parse HEAD)"

    # Uses the latest tag as the version - prefer this if you're only indexing specific tags
    bundle exec scip-ruby . --index-file index.scip --gem-metadata "my-gem-name@$(git describe --tags --abbrev=0)"
    ```

The generated `index.scip` file can be uploaded
to a Sourcegraph instance using the [Sourcegraph CLI](https://github.com/sourcegraph/src-cli).

If you're curious about the internals of the index,
such as which files were indexed,
check out the [SCIP CLI](https://github.com/sourcegraph/scip/blob/main/docs/CLI.md).

## Download binary and index

You can download a
[release binary](https://github.com/sourcegraph/scip-ruby/releases)
and run it directly, similar to invoking Sorbet.

```bash
curl -L "https://github.com/sourcegraph/scip-ruby/releases/latest/download/scip-ruby-x86_64-$(uname -s | tr '[:upper:]' '[:lower:]')" -o scip-ruby && chmod +x scip-ruby

# If using in CI with 'set -e', make sure to wrap the
# scip-ruby invocation in 'set +e' followed by 'set -e'
# so that indexing failures are non-blocking.
./scip-ruby --index-file index.scip --gem-metadata "my-gem-name@M.N.P"
```

The generated index can be uploaded to a Sourcegraph instance
using the [Sourcegraph CLI](https://github.com/sourcegraph/src-cli) (v3.43.0 or newer).
Typically, the command looks like:

```bash
SRC_ACCESS_TOKEN="your token" SRC_ENDPOINT="url for Sourcegraph instance" src code-intel upload -file=/path/to/index.scip
```

For more details, see the Sourcegraph CLI docs.

## Contributing

See the [Contributing docs](./docs/scip-ruby/CONTRIBUTING.md).
