# typed: true

module Labeled
  include Kernel

  def label
    "labeled"
  end
end

module Tagged
  include Kernel

  def label
    "tagged"
  end
end

class Spare
end

class ToySelection
  extend T::Sig

  sig do
    params(entry: T.any(Labeled, Spare, Tagged), fallback: T.any(Labeled, Tagged)).void
  end
  def self.describe(entry, fallback)
    selected = if entry.nil?
      entry
    else
      fallback
    end
    selected.label
  end
end
