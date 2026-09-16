 # typed: true
 # check-errors: true
 # Adapted from test/testdata/lsp/hover_it_param.rb and
 # test/testdata/resolver/it_param_method_vs_local.rb / it_param_method_vs_param.rb.
 
 [1, 2].map { it + it }
#             ^^ definition local 1$119448696
#             ^^ reference local 1$119448696
#                ^ reference [..] Integer#+().
#                  ^^ reference local 1$119448696
 ["a", "b"].map { it.upcase }
#                 ^^ definition local 2$119448696
#                 ^^ reference local 2$119448696
#                    ^^^^^^ reference [..] String#upcase().
 
 [[1, 2], [3, 4]].map do
   it.map { it + it }
#  ^^ definition local 3$119448696
#  ^^ reference local 3$119448696
#           ^^ definition local 4$119448696
#           ^^ reference local 4$119448696
#              ^ reference [..] Integer#+().
#                ^^ reference local 4$119448696
   it.length
#  ^^ reference local 3$119448696
 end
 
#⌄ enclosing_range_start [..] ImplicitItPrecedence#
 class ImplicitItPrecedence
#      ^^^^^^^^^^^^^^^^^^^^ definition [..] ImplicitItPrecedence#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(value: Integer).returns(String) }
#                      ^^^^^^^ reference [..] Integer#
#                                       ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] ImplicitItPrecedence#it().
   def it(value)
#      ^^ definition [..] ImplicitItPrecedence#it().
#         ^^^^^ definition local 1$1194886160
     value.to_s
#    ^^^^^ reference local 1$1194886160
#          ^^^^ reference [..] Integer#to_s().
   end
#    ⌃ enclosing_range_end [..] ImplicitItPrecedence#it().
 
#  ⌄ enclosing_range_start [..] ImplicitItPrecedence#implicit_parameter().
   def implicit_parameter
#      ^^^^^^^^^^^^^^^^^^ definition [..] ImplicitItPrecedence#implicit_parameter().
     [1, 2].map { it + it }
#                 ^^ definition local 1$1457465026
#                 ^^ reference local 1$1457465026
#                    ^ reference [..] Integer#+().
#                      ^^ reference local 1$1457465026
     [1, 2].map { it(it).upcase }
#                 ^^ reference [..] ImplicitItPrecedence#it().
#                    ^^ definition local 2$1457465026
#                    ^^ reference local 2$1457465026
#                        ^^^^^^ reference [..] String#upcase().
     [1, 2].map { self.it(it).upcase }
#                      ^^ reference [..] ImplicitItPrecedence#it().
#                         ^^ definition local 3$1457465026
#                         ^^ reference local 3$1457465026
#                             ^^^^^^ reference [..] String#upcase().
     it(1).upcase
#    ^^ reference [..] ImplicitItPrecedence#it().
#          ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] ImplicitItPrecedence#implicit_parameter().
 
#  ⌄ enclosing_range_start [..] ImplicitItPrecedence#existing_local().
   def existing_local
#      ^^^^^^^^^^^^^^ definition [..] ImplicitItPrecedence#existing_local().
     it = "outer"
#    ^^ definition local 1$3790959852
     [1, 2].map { it.upcase }
#                 ^^ reference local 1$3790959852
#                    ^^^^^^ reference [..] String#upcase().
     [1, 2].map { it(it.length).upcase }
#                 ^^ reference [..] ImplicitItPrecedence#it().
#                    ^^ reference local 1$3790959852
#                       ^^^^^^ reference [..] String#length().
#                               ^^^^^^ reference [..] String#upcase().
     it.downcase
#    ^^ reference local 1$3790959852
#       ^^^^^^^^ reference [..] String#downcase().
   end
#    ⌃ enclosing_range_end [..] ImplicitItPrecedence#existing_local().
 end
#  ⌃ enclosing_range_end [..] ImplicitItPrecedence#
