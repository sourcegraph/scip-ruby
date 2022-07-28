# typed: true

class C1
  extend T::Sig

  sig { returns(T::Boolean) }
  def m1
    true
  end
end
