# typed: true

# Entirely synthetic: a rescue joins nil with tuples whose first element
# changes from a literal to Integer, alongside a hash shape and string.
class ToyCatalog
  extend T::Sig

  sig { params(count: Integer).void }
  def self.record(count)
    entry = nil
    begin
      entry = [7, {"label" => "toy"}, "ready"]
    rescue StandardError
      entry = [count, {"label" => "toy"}, "fallback"]
    end

    ToyReporter.new.describe(entry)
  end
end

# Definitions and references after the failing method must still be indexed.
class ToyReporter
  def describe(value)
    value.to_s
  end
end

ToyCatalog.record(11)
