# typed: true
# check-errors: true
# options: showDocs

class HoverBox
  extend T::Sig
  extend T::Generic
  Elem = type_member { {upper: Numeric} }

  sig { params(value: Elem).void }
  def initialize(value)
    @value = value
  end

  sig { params(value: Elem).returns(Elem) }
  def echo(value)
    value
  end

  sig { type_parameters(:Item).params(value: Elem, other: T.type_parameter(:Item)).returns(T.type_parameter(:Item)) }
  def generic(value, other)
    other
  end

  alias copied echo
end

class HoverFixed
  extend T::Sig
  extend T::Generic
  Elem = type_member { {fixed: Integer} }

  sig { params(value: Elem).returns(Elem) }
  def echo(value)
    value
  end
end

class HoverTemplate
  extend T::Sig
  extend T::Generic
  Elem = type_template

  sig { params(value: Elem).returns(Elem) }
  def self.echo(value)
    value
  end
end

class OrdinaryHovers
  extend T::Sig

  sig { params("value": String).returns(String) }
  def self.quoted(value)
    value
  end

  sig { params("*": Integer, "**": String, "&": T.proc.void).void }
  def self.anonymous(*, **, &)
  end

  sig { params(value: String, count: Integer, rest: Symbol, flag: T::Boolean, label: String, extras: Integer, block: T.proc.params(value: String).returns(String)).returns(String) }
  def self.mixed(value, count = 1, *rest, flag:, label: "", **extras, &block)
    block.call(value)
  end
end

box = HoverBox[Integer].new(1)
box.echo(1).abs
box.copied(1).abs
box.generic(1, "a").upcase
HoverFixed.new.echo(1).abs
OrdinaryHovers.quoted("a").upcase
OrdinaryHovers.mixed("a", flag: true) { |value| value.upcase }
