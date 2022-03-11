# typed: true

module MyModule

end

MyAlias = MyModule
# ^ apply-rename: [A] newName: Foo

puts(MyAlias)
