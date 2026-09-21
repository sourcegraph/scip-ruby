# typed: true
# check-errors: true

# A real contract can return something other than an instance of the receiver.
T.must(Gem::Version.new('2.0')).upcase
