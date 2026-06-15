# typed: true

# T.must, T.assert_type!, T.absurd, T.bind. Other T.* operations
# (T.let, T.cast, T.unsafe, T.reveal_type) are already covered elsewhere.

class Container
  extend T::Sig

  sig { params(x: T.nilable(String)).returns(Integer) }
  def use_must(x)
    T.must(x).length
  end

  sig { params(x: T.untyped).returns(Integer) }
  def use_assert_type(x)
    T.assert_type!(x, Integer)
    x + 1
  end

  Variant = T.type_alias { T.any(Integer, String) }

  sig { params(x: Variant).returns(Integer) }
  def use_absurd(x)
    case x
    when Integer then x + 1
    when String  then x.length
    else
      T.absurd(x)
    end
  end

  sig { returns(T.proc.void) }
  def use_bind
    proc do
      T.bind(self, Integer)
      _ = self + 1
      nil
    end
  end
end
