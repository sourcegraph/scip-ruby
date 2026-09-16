# typed: true

class ToyBox
  def mark
    "box"
  end
end

class ToyShelf
  def mark
    "shelf"
  end
end

class ToyFactory
  extend T::Sig

  sig {params(entry: T.any(T.class_of(ToyBox), Symbol, T.class_of(ToyShelf))).void}
  def self.build(entry)
    klass = if entry.is_a?(Class)
      entry
    else
      ToyShelf
    end
    klass.new.mark
  end
end

ToyFactory.build(ToyBox)
