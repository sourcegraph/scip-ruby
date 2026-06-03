# typed: strict

# Exercises T::Helpers `requires_ancestor { ... }`.

module Greetable
  extend T::Helpers
  extend T::Sig
  abstract!

  requires_ancestor { Kernel }

  sig { abstract.returns(String) }
  def name; end

  sig { void }
  def greet
    puts("Hello, " + name)
  end
end

class GreetableClass
  extend T::Sig
  include Greetable

  sig { override.returns(String) }
  def name
    "World"
  end
end
