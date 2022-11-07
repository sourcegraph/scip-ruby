Download the binary for your platform using:

```bash
TAG=TAG_PLACEHOLDER \
OS="$(uname -s | tr '[:upper:]' '[:lower:]')" \
RELEASE_URL="https://github.com/sourcegraph/scip-ruby/releases/download/$TAG" \
bash -c 'curl -L "$RELEASE_URL/scip-ruby-x86_64-$OS" -o scip-ruby' && \
chmod +x scip-ruby
```

The `-debug*` binaries are meant for debugging issues (for example, if you run into a crash with `scip-ruby`), and are not recommended for general use.

OS key:
- Darwin 20 ~ macOS 11 Big Sur
- Darwin 21 ~ macOS 12 Monterey
- Darwin 22 ~ macOS 13 Ventura
