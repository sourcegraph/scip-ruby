# typed: true

class ToyLabels
  extend T::Sig

  sig do
    params(
      item: T.any(Integer, {label: String}, Symbol),
      candidate: T.any(Integer, Symbol, T::Hash[Symbol, String])
    ).void
  end
  def self.describe(item, candidate)
    if item == candidate
      if candidate.is_a?(Hash)
        ToyPrinter.new.print_label(candidate[:label])
      end
    end
  end
end

class ToyPrinter
  extend T::Sig

  sig {params(value: String).returns(String)}
  def print_label(value)
    value.upcase
  end
end

ToyLabels.describe({label: "sample"}, {label: "sample"})
