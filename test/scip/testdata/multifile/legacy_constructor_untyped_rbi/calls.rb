# typed: true
# check-errors: true

# An explicit untyped contract must remain untyped.
Gem::Version.new('2.0') >= Gem::Version.new('1.0')
