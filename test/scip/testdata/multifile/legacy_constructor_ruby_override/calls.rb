# typed: true
# check-errors: true

# A Ruby body, even an empty one, must not acquire the old payload contract.
class Gem::Version
  def self.new(version); end
end

Gem::Version.new('2.0') >= Gem::Version.new('1.0')
