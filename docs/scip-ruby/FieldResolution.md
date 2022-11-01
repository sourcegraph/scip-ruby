# Field resolution

In Sorbet, fields on classes can be declared or undeclared.

Declared fields are defined with `@fieldName = T.let(initialValue, type)`
in the special [`initialize` method](https://www.rubyguides.com/2019/01/ruby-initialize-method/),
inside a class or a module.

Undeclared fields are those which lack such a definition.

Sorbet automatically propagates declared fields down inheritance hierarchies
but not down module inclusions. For example, with code like:

```ruby
class C
  def initialize
    @x = T.let(0, Integer)
    @z = T.let(0, Integer)
  end
  
  def set_w
    @w = 0
  end
end

module M
  def initialize
    @y = T.let(0, Integer)
    @z = T.let(0, Integer)
  end
end 
    
class D < C
  include M
  def sum
    @w + @x + @y + @z
  end
end
```

In `C`:
- `@x` and `@z` will have `SymbolRef`s corresponding to `C#@x` and `C#@z` respectively.
- `@w` be a `Magic_undeclaredFieldStub`.

In `M#initialize`:
- `@y` and `@z` will have `SymbolRef`s corresponding to `M#@y` and `M#@z` respectively.

In `D#sum`:
- `@w` and `@y` will be `Magic_undeclaredFieldStub`.
- `@x` and `@z` will have `SymbolRef`s corresponding to `C#@x` and `C#@z` respectively.

Notice that Sorbet is using the same symbol across classes
when a declared field is accessed.
This is similar to how scip-java works.

The constraints we have in scip-ruby are a little different,
because fields may not be declared,
and we need this to work in a cross-repo setting.

In scip-ruby, we do something a little different.
- The symbol name always corresponds to the containing class or module name.
- If the symbol is in a class, we will emit an `is_definition` relationship
  between the symbol and the matching symbol in the closest ancestor class,
  as well as `is_reference` relationships for matching symbols in the inclusion
  hierarchy.
- If the symbol is in a module, we will emit an `is_definition`
- We will emit an `is_definition` relationship between the symbol
  and the matching symbol in the closest parent class (or module,
  if we're in a module),
  and `is_reference` relationships between the symbol
  and matching symbols in
