# typed: true

# Explicit-arg super (as opposed to implicit-arg, which is implicit_super_arg.rb)
# Documents whether scip-ruby emits a reference to the parent method at `super`.

class Parent
  def greet(name)
    "Hi, " + name
  end
end

class Child < Parent
  def greet(name)
    super(name)
  end
end

class GrandChild < Child
  def greet(name)
    base = super("child of " + name)
    base + "!"
  end
end

def trigger
  _ = GrandChild.new.greet("x")
  return
end
