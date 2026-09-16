# typed: true
# check-errors: true

module Types
  extend T::Sig
  Renamed = T.type_alias { Text }

  sig { params(value: Text).returns(Checked) }
  def self.echo(value)
    T.let(value, Renamed).upcase
  end

  class Box
    sig { params(value: Elem).returns(Elem) }
    def echo(value)
      T.let(value, Elem)
    end
  end
end

class AliasConsumer
  extend T::Sig

  sig { params(value: Types::Checked).returns(::Types::Text) }
  def echo(value)
    T.let(value, Types::Renamed).upcase
  end

  sig { params(value: OtherTypes::Text).returns(Types::Other) }
  def numeric(value)
    value.abs
  end
end

Types.echo("text").upcase
Types::Box[String].new.echo("text").upcase
AliasConsumer.new.echo("text").upcase
AliasConsumer.new.numeric(1).abs
