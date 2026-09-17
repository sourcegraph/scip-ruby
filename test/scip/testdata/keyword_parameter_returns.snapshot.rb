 # typed: true
 # check-errors: true
 # options: showDocs
 
#⌄ enclosing_range_start [..] KeywordParameterReturns#
 class KeywordParameterReturns
#      ^^^^^^^^^^^^^^^^^^^^^^^ definition [..] KeywordParameterReturns#
#      documentation
#      | ```ruby
#      | class KeywordParameterReturns
#      | ```
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(value: String, values: T.nilable(T::Array[String])).returns(String) }
#                      ^^^^^^ reference [..] String#
#                                                         ^^^^^^ reference [..] String#
#                                                                           ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordParameterReturns#guarded().
   def guarded(value:, values: nil)
#      ^^^^^^^ definition [..] KeywordParameterReturns#guarded().
#      documentation
#      | ```ruby
#      | sig do
#      |   params(
#      |     value: String,
#      |     values: T.nilable(T::Array[String])
#      |   )
#      |   .returns(String)
#      | end
#      | def guarded(value:, values: …)
#      | ```
#              ^^^^^ definition [..] KeywordParameterReturns#guarded().(value)
#              documentation
#              | ```ruby
#              | value (String)
#              | ```
#                      ^^^^^^ definition [..] KeywordParameterReturns#guarded().(values)
#                      documentation
#                      | ```ruby
#                      | values (T.nilable(T::Array[String]))
#                      | ```
     return value if values.nil?
#           ^^^^^ reference [..] KeywordParameterReturns#guarded().(value)
#                    ^^^^^^ reference [..] KeywordParameterReturns#guarded().(values)
#                           ^^^^ reference [..] Kernel#`nil?`().
#                           ^^^^ reference [..] NilClass#`nil?`().
     return(value) if values.empty?
#           ^^^^^ reference [..] KeywordParameterReturns#guarded().(value)
#                     ^^^^^^ reference [..] KeywordParameterReturns#guarded().(values)
#                     override_documentation
#                     | ```ruby
#                     | values (T::Array[String])
#                     | ```
#                            ^^^^^^ reference [..] Array#`empty?`().
     value
#    ^^^^^ reference [..] KeywordParameterReturns#guarded().(value)
   end
#    ⌃ enclosing_range_end [..] KeywordParameterReturns#guarded().
 
   sig { params(value: String).returns(String) }
#                      ^^^^^^ reference [..] String#
#                                      ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordParameterReturns#nested().
   def nested(value:)
#      ^^^^^^ definition [..] KeywordParameterReturns#nested().
#      documentation
#      | ```ruby
#      | sig { params(value: String).returns(String) }
#      | def nested(value:)
#      | ```
#             ^^^^^ definition [..] KeywordParameterReturns#nested().(value)
#             documentation
#             | ```ruby
#             | value (String)
#             | ```
     [1].each { return value }
#        ^^^^ reference [..] Array#each().
#                      ^^^^^ reference [..] KeywordParameterReturns#nested().(value)
     value
#    ^^^^^ reference [..] KeywordParameterReturns#nested().(value)
   end
#    ⌃ enclosing_range_end [..] KeywordParameterReturns#nested().
 
   sig { params(value: String).returns(String) }
#                      ^^^^^^ reference [..] String#
#                                      ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordParameterReturns#block_exits().
   def block_exits(value:)
#      ^^^^^^^^^^^ definition [..] KeywordParameterReturns#block_exits().
#      documentation
#      | ```ruby
#      | sig { params(value: String).returns(String) }
#      | def block_exits(value:)
#      | ```
#                  ^^^^^ definition [..] KeywordParameterReturns#block_exits().(value)
#                  documentation
#                  | ```ruby
#                  | value (String)
#                  | ```
     [1].each { next value }
#        ^^^^ reference [..] Array#each().
#                    ^^^^^ reference [..] KeywordParameterReturns#block_exits().(value)
     -> { return value }.call
#    ^^ reference [..] Kernel#
#    ^^ reference [..] Kernel#lambda().
#                ^^^^^ reference [..] KeywordParameterReturns#block_exits().(value)
#                        ^^^^ reference [..] Proc0#call().
   end
#    ⌃ enclosing_range_end [..] KeywordParameterReturns#block_exits().
 
   sig { params(value: String).returns(String) }
#                      ^^^^^^ reference [..] String#
#                                      ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordParameterReturns#positional().
   def positional(value)
#      ^^^^^^^^^^ definition [..] KeywordParameterReturns#positional().
#      documentation
#      | ```ruby
#      | sig { params(value: String).returns(String) }
#      | def positional(value)
#      | ```
#                 ^^^^^ definition local 1$235276553
#                 documentation
#                 | ```ruby
#                 | value (String)
#                 | ```
     return value
#           ^^^^^ reference local 1$235276553
   end
#    ⌃ enclosing_range_end [..] KeywordParameterReturns#positional().
 end
#  ⌃ enclosing_range_end [..] KeywordParameterReturns#
