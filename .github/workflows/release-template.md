Download the binary for your platform using:

```bash
TAG=TAG_PLACEHOLDER \
ARCH="$(uname -m)" \
OS="$(uname -s | tr '[:upper:]' '[:lower:]')" \
RELEASE_URL="https://github.com/sourcegraph/scip-ruby/releases/download/$TAG" \
bash -c 'curl -L "$RELEASE_URL/scip-ruby-$ARCH-$OS" -o scip-ruby' && \
chmod +x scip-ruby
```

The `-asserts*` binaries are meant for debugging issues (for example, if you run into a crash with `scip-ruby`), and are not recommended for general use.

OS key:
- Darwin 22 ~ macOS 13 Ventura
- Darwin 23 ~ macOS 14 Sonoma
