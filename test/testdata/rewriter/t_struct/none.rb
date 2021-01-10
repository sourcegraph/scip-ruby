# typed: strict

class None < T::Struct; end

None.new
None.new(foo: 3) # error: Too many arguments provided for method `initialize` on `None`. Expected: `0`, got: `1`
