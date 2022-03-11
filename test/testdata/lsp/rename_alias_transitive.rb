# typed: true

module MyModule; end

class Parent
  MyAlias = MyModule
  # ^ apply-rename: [A] newName: Foo
end

class Child < Parent
  puts(MyAlias)
end
