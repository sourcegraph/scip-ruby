# typed: true
# options: showDocs

class SafeNavigationHover
  extend T::Sig

  sig { params(value: String, maybe: T.nilable(String), absent: NilClass).void }
  def example(value, maybe, absent)
    # The dead nil path must not hide the live assignment's type, even if unused.
    unused_length = value&.length
    used_length = value&.length
    puts used_length

    # Both reachable paths contribute to the definition hover.
    nullable_length = maybe&.length
    puts nullable_length
    always_nil = absent&.length
    puts always_nil

    # A later assignment must not change the first definition's hover.
    reassigned = value&.length
    reassigned = 'changed'
    puts reassigned

    # Nilability also applies to aggregate return types.
    chars = maybe&.chars
    puts chars
    chained = maybe&.strip&.length
    puts chained
  end
end
