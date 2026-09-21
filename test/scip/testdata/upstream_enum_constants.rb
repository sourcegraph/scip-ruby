# typed: true
# check-errors: true
# Adapted from test/testdata/rewriter/enum_with_constants.rb.

class CardSuit < T::Enum
  extend T::Sig

  enums do
    Spades = new
    Hearts = new
    Diamonds = new
  end

  Reds = T.let([Hearts, Diamonds], T::Array[CardSuit])
  Red = T.type_alias { T.any(Hearts, Diamonds) }
  Description = "playing cards"

  sig { returns(T::Boolean) }
  def red?
    Reds.include?(self)
  end

  sig { params(suit: Red).returns(String) }
  def self.describe_red(suit)
    suit.serialize
  end
end

CardSuit::Hearts.red?
CardSuit::Reds.each { |suit| suit.red? }
CardSuit::Description.upcase
CardSuit.describe_red(CardSuit::Diamonds).upcase
