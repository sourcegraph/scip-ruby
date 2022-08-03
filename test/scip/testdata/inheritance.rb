# typed: true

class Z1
  extend T::Sig

  sig { params(a: T::Boolean).void }
  def write_f(a)
    @f = a
  end

  sig { returns(T::Boolean) }
  def read_f?
    @f
  end
end

class Z2
  extend T::Sig

  sig { returns(T::Boolean) }
  def read_f?
    @f
  end

  sig { params(a: T::Boolean).void }
  def write_f(a)
    @f = a
  end
end

class Z3 < Z1
  extend T::Sig

  sig { returns(T::Boolean) }
  def read_f_plus_1?
    @f + 1
  end
end

class Z4 < Z3
  extend T::Sig

  sig { params(a: T::Boolean).void }
  def write_f_plus_1(a)
    write_f(a)
    @f = read_f_plus_1?
  end
end

