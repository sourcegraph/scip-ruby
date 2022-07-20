# typed: true

def f()
  T.let(true, T::Boolean)
end

module M
  module_function
  sig { returns(T::Boolean) }
  def b
    true
  end
end
