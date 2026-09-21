# typed: true

class ToyCards
  extend T::Sig

  sig do
    params(
      card: T.any(T.nilable({label: String}), {count: Integer}),
      candidate: T.nilable(T::Hash[T.untyped, T.untyped])
    ).void
  end
  def self.compare_optional(card, candidate)
    if candidate == card
      ToyPrinter.new.print_card(card)
    end
  end

  sig do
    params(
      card: T.any(T.nilable({label: String}), {count: Integer}),
      candidate: T.nilable(T::Hash[T.untyped, T.untyped])
    ).void
  end
  def self.compare_required(card, candidate)
    card = T.must(card)
    if card == candidate
      ToyPrinter.new.print_card(card)
    end
  end
end

class ToyPrinter
  extend T::Sig

  sig {params(card: T.nilable(T::Hash[T.untyped, T.untyped])).returns(String)}
  def print_card(card)
    card.inspect
  end
end

ToyCards.compare_optional({label: "sample"}, nil)
ToyCards.compare_required({count: 7}, {count: 7})

# Preserving shapes and tuples in mixed unions must preserve method navigation too.
# This models a mixed-input validation loop, including empty aggregates.
[7, true, {}, [], 0.5].each do |value|
  value.inspect
end

# Direct aggregate receivers use the same Hash/Array methods.
{label: "toy"}.inspect
[7, "toy"].inspect
