Download the binary for your platform using:

```bash
TAG=TAG_PLACEHOLDER \
OS="$(uname -s | tr '[:upper:]' '[:lower:]')" \
RELEASE_URL="https://github.com/sourcegraph/scip-ruby/releases/download/$TAG" \
curl -L "$RELEASE_URL/scip-ruby-x86_64-$OS" -o scip-ruby && \
chmod +x scip-ruby
```

NOTE: The `-debug*` binaries are meant for debugging issues (for example, if you run into a crash with `scip-ruby`), and are not recommended for general use.
