 # typed: true
 # options: showDocs
 # check-errors: true
 
#⌄ enclosing_range_start [..] LegacySingleArgumentUnion#
 class LegacySingleArgumentUnion
#      ^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] LegacySingleArgumentUnion#
#      documentation
#      | ```ruby
#      | class LegacySingleArgumentUnion
#      | ```
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   Name = T.type_alias { T.any(String, Symbol) }
#  ^^^^ definition [..] LegacySingleArgumentUnion#Name.
#  documentation
#  | ```ruby
#  | Name (Runtime object representing type: T.any(String, Symbol))
#  | ```
#                              ^^^^^^ reference [..] String#
#                                      ^^^^^^ reference [..] Symbol#
   Normalize = T.let(T.unsafe(nil), T.proc.params(name: T.any(Name)).returns(Symbol)) # error: Not enough arguments provided for method `T.any`. Expected: `2+`, got: `1`
#  ^^^^^^^^^ definition [..] LegacySingleArgumentUnion#Normalize.
#  documentation
#  | ```ruby
#  | Normalize (T.proc.params(arg0: T.any(String, Symbol)).returns(Symbol))
#  | ```
#                                                             ^^^^ reference [..] LegacySingleArgumentUnion#Name.
#                                                                            ^^^^^^ reference [..] Symbol#
 
   sig { params(value: T.any(String)).returns(String) } # error: Not enough arguments provided for method `T.any`. Expected: `2+`, got: `1`
#                            ^^^^^^ reference [..] String#
#                                             ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] LegacySingleArgumentUnion#normalize().
   def normalize(value)
#      ^^^^^^^^^ definition [..] LegacySingleArgumentUnion#normalize().
#      documentation
#      | ```ruby
#      | sig { params(value: String).returns(String) }
#      | def normalize(value)
#      | ```
#                ^^^^^ definition local 1$2938091192
#                documentation
#                | ```ruby
#                | value (String)
#                | ```
     value.upcase
#    ^^^^^ reference local 1$2938091192
#          ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] LegacySingleArgumentUnion#normalize().
 
   # Invalid empty unions still have no recoverable type.
   sig { params(value: T.any).void } # error: Not enough arguments provided for method `T.any`. Expected: `2+`, got: `0`
#  ⌄ enclosing_range_start [..] LegacySingleArgumentUnion#empty().
   def empty(value)
#      ^^^^^ definition [..] LegacySingleArgumentUnion#empty().
#      documentation
#      | ```ruby
#      | sig { params(value: T.untyped).void }
#      | def empty(value)
#      | ```
#      documentation
#      | Invalid empty unions still have no recoverable type.
#            ^^^^^ definition local 1$1772829450
#            documentation
#            | ```ruby
#            | value (T.untyped)
#            | ```
     value.upcase
#    ^^^^^ reference local 1$1772829450
   end
#    ⌃ enclosing_range_end [..] LegacySingleArgumentUnion#empty().
 end
#  ⌃ enclosing_range_end [..] LegacySingleArgumentUnion#
