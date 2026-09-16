 # typed: true
 # options: showDocs
 # Adapted from test/testdata/lsp/hover_mlhs_assign.rb.
 
 extend T::Sig
#^^^^^^ reference [..] Kernel#extend().
#       ^ reference [..] T#
#          ^^^ reference [..] T#Sig#
 
 sig { returns([Integer, Integer]) }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#               ^^^^^^^ reference [..] Integer#
#                        ^^^^^^^ reference [..] Integer#
#⌄ enclosing_range_start [..] Object#returns_tuple().
 def returns_tuple = [0, 0]
#    ^^^^^^^^^^^^^ definition [..] Object#returns_tuple().
#    documentation
#    | ```ruby
#    | sig { returns([Integer, Integer]) }
#    | def returns_tuple
#    | ```
#                         ⌃ enclosing_range_end [..] Object#returns_tuple().
 
 arg0, arg1 = returns_tuple
#^^^^ definition local 9$119448696
#documentation
#| ```ruby
#| arg0 (Integer)
#| ```
#      ^^^^ definition local 10$119448696
#      documentation
#      | ```ruby
#      | arg1 (Integer)
#      | ```
#             ^^^^^^^^^^^^^ reference [..] Object#returns_tuple().
 puts(arg0, arg1)
#^^^^ reference [..] Kernel#puts().
#     ^^^^ reference local 9$119448696
#           ^^^^ reference local 10$119448696
 
 sig { returns([Integer, Integer, Integer]) }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#               ^^^^^^^ reference [..] Integer#
#                        ^^^^^^^ reference [..] Integer#
#                                 ^^^^^^^ reference [..] Integer#
#⌄ enclosing_range_start [..] Object#returns_3tuple().
 def returns_3tuple = [0, 0, 0]
#    ^^^^^^^^^^^^^^ definition [..] Object#returns_3tuple().
#    documentation
#    | ```ruby
#    | sig { returns([Integer, Integer, Integer]) }
#    | def returns_3tuple
#    | ```
#                             ⌃ enclosing_range_end [..] Object#returns_3tuple().
 
 arg0, *arg1 = returns_3tuple
#^^^^ reference (write) local 9$119448696
#       ^^^^ reference (write) local 10$119448696
#       override_documentation
#       | ```ruby
#       | arg1 (T::Array[Integer])
#       | ```
#              ^^^^^^^^^^^^^^ reference [..] Object#returns_3tuple().
 puts(arg0, arg1)
#^^^^ reference [..] Kernel#puts().
#     ^^^^ reference local 9$119448696
#           ^^^^ reference local 10$119448696
#           override_documentation
#           | ```ruby
#           | arg1 (T::Array[Integer])
#           | ```
 
 sig { returns(T::Array[String]) }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#              ^ reference [..] T#
#                 ^^^^^ reference [..] T#Array#
#                       ^^^^^^ reference [..] String#
#⌄ enclosing_range_start [..] Object#returns_string_array().
 def returns_string_array = ["a", "b", "c", "d"]
#    ^^^^^^^^^^^^^^^^^^^^ definition [..] Object#returns_string_array().
#    documentation
#    | ```ruby
#    | sig { returns(T::Array[String]) }
#    | def returns_string_array
#    | ```
#                                              ⌃ enclosing_range_end [..] Object#returns_string_array().
 
 arg0, arg1 = returns_string_array
#^^^^ reference (write) local 9$119448696
#override_documentation
#| ```ruby
#| arg0 (T.nilable(String))
#| ```
#      ^^^^ reference (write) local 10$119448696
#      override_documentation
#      | ```ruby
#      | arg1 (T.nilable(String))
#      | ```
#             ^^^^^^^^^^^^^^^^^^^^ reference [..] Object#returns_string_array().
 puts(arg0, arg1)
#^^^^ reference [..] Kernel#puts().
#     ^^^^ reference local 9$119448696
#     override_documentation
#     | ```ruby
#     | arg0 (T.nilable(String))
#     | ```
#           ^^^^ reference local 10$119448696
#           override_documentation
#           | ```ruby
#           | arg1 (T.nilable(String))
#           | ```
