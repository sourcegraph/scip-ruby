# typed: true

class MethodNameManipulation
  extend T::Sig
  delegate :ball, to: :thing, private: true, allow_nil: true
  delegate :foo, :bar, prefix: 'string', to: :thing
  delegate :foo, :bar, prefix: :symbol, to: :thing

  sig {void}
  def usages
    ball(thing: 0) {}
    string_foo
    string_bar
    symbol_foo {}
    symbol_bar(1, 2) {}
  end
end
