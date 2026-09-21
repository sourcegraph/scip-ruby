# typed: strong

# At `typed: strong` Sorbet requires that nothing be T.untyped. Locks in
# indexer behavior for fully-typed code.

class StrongClass
  extend T::Sig

  sig { params(x: Integer).returns(Integer) }
  def add_one(x)
    x + 1
  end

  sig { params(x: String).returns(String) }
  def shout(x)
    x.upcase
  end
end

class StrongUse
  extend T::Sig

  sig { void }
  def call_them
    s = StrongClass.new
    _ = s.add_one(1)
    _ = s.shout("hi")
    nil
  end
end
