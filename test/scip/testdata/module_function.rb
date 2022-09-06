# typed: true

module M
  sig { returns(T::Boolean) }
  def b
    true
  end

  module_function :b
end
