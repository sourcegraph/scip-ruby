# typed: true

# Current payload RBIs mark these methods abstract. Older payloads did not,
# so indexing a checked-in sorbet-runtime must still visit their Ruby bodies.
class T::Types::Base
  def valid?(obj)
    raise NotImplementedError
  end

  def name
    value = "abstract".upcase
    value
  end
end

class AbstractBody
  extend T::Sig
  extend T::Helpers
  abstract!

  sig { abstract.params(value: String).returns(String) }
  def render(value = "default".upcase)
    value.strip
  end
end

# Empty declarations have no handwritten body to index.
class EmptyAbstractBody
  extend T::Sig, T::Helpers
  abstract!
  sig { abstract.returns(String) }
  def name; end
end
