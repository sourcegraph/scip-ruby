# typed: strict

module Test::Foo::Bar
  class Thing
    extend T::Sig

    sig {void}
    def self.hello; end
  end

  class OtherThing
  end
end
