# typed: true
# check-errors: true

class KeywordErrors
  extend T::Sig
  sig { params(customer: String).void }
  def deliver(customer:)
  end
end

receiver = KeywordErrors.new
receiver.deliver(customer: "Ada", missing: "x") # error: Unrecognized keyword argument `missing` passed for method `KeywordErrors#deliver`
receiver.deliver(customer: 1) # error: Expected `String` but found `Integer(1)` for argument `customer`
