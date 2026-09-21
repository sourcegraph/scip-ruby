# typed: true

class Gem::Version
  extend T::Sig
  sig { params(version: String).returns(T.untyped) }
  def self.new(version); end
end
