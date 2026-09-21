 # typed: true
 # check-errors: true
 # options: showDocs
 
 # File-level lambdas share the static initializer's CFG.
 display_name = lambda do |name|
#^^^^^^^^^^^^ definition local 2$217974539
#documentation
#| ```ruby
#| display_name (T.proc.params(arg0: T.untyped).returns(T.untyped))
#| ```
#               ^^^^^^ reference [..] Kernel#lambda().
#                          ^^^^ definition local 1$217974539
#                          documentation
#                          | ```ruby
#                          | name (T.untyped)
#                          | ```
   return name unless name.include?("::")
#         ^^^^ reference local 1$217974539
#                     ^^^^ reference local 1$217974539
   name.split("::").first
#  ^^^^ reference local 1$217974539
 end
 display_name.call("provider")
#^^^^^^^^^^^^ reference local 2$217974539
#             ^^^^ reference [..] Proc1#call().
 
#⌄ enclosing_range_start [..] ReturnOperands#
 class ReturnOperands
#      ^^^^^^^^^^^^^^ definition [..] ReturnOperands#
#      documentation
#      | ```ruby
#      | class ReturnOperands
#      | ```
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(value: String, condition: T::Boolean).returns(String) }
#                      ^^^^^^ reference [..] String#
#                                            ^^^^^^^ reference [..] T#Boolean.
#                                                             ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] ReturnOperands#guarded().
   def guarded(value, condition)
#      ^^^^^^^ definition [..] ReturnOperands#guarded().
#      documentation
#      | ```ruby
#      | sig { params(value: String, condition: T::Boolean).returns(String) }
#      | def guarded(value, condition)
#      | ```
#              ^^^^^ definition local 1$157545206
#              documentation
#              | ```ruby
#              | value (String)
#              | ```
#                     ^^^^^^^^^ definition local 2$157545206
#                     documentation
#                     | ```ruby
#                     | condition (T::Boolean)
#                     | ```
     return(value) if condition
#           ^^^^^ reference local 1$157545206
     [1].each { return value }
#        ^^^^ reference [..] Array#each().
#                      ^^^^^ reference local 1$157545206
     value
#    ^^^^^ reference local 1$157545206
   end
#    ⌃ enclosing_range_end [..] ReturnOperands#guarded().
 
   sig { params(value: String).returns(String) }
#                      ^^^^^^ reference [..] String#
#                                      ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] ReturnOperands#block_exits().
   def block_exits(value)
#      ^^^^^^^^^^^ definition [..] ReturnOperands#block_exits().
#      documentation
#      | ```ruby
#      | sig { params(value: String).returns(String) }
#      | def block_exits(value)
#      | ```
#                  ^^^^^ definition local 1$104447725
#                  documentation
#                  | ```ruby
#                  | value (String)
#                  | ```
     [1].each { next value }
#        ^^^^ reference [..] Array#each().
#                    ^^^^^ reference local 1$104447725
     -> { return value }.call
#    ^^ reference [..] Kernel#
#    ^^ reference [..] Kernel#lambda().
#                ^^^^^ reference local 1$104447725
#                        ^^^^ reference [..] Proc0#call().
   end
#    ⌃ enclosing_range_end [..] ReturnOperands#block_exits().
 end
#  ⌃ enclosing_range_end [..] ReturnOperands#
