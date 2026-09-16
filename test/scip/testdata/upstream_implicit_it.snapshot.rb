 # typed: true
 # check-errors: true
 # Adapted from test/testdata/lsp/hover_it_param.rb and
 # test/testdata/resolver/it_param_method_vs_local.rb / it_param_method_vs_param.rb.
 
 [1, 2].map { it + it }
#       ^^^ reference [..] Array#map().
#             ^^ definition local 1$217974539
#             ^^ reference local 1$217974539
#                ^ reference [..] Integer#+().
#                  ^^ reference local 1$217974539
 ["a", "b"].map { it.upcase }
#           ^^^ reference [..] Array#map().
#                 ^^ definition local 2$217974539
#                 ^^ reference local 2$217974539
#                    ^^^^^^ reference [..] String#upcase().
 
 [[1, 2], [3, 4]].map do
#                 ^^^ reference [..] Array#map().
   it.map { it + it }
#  ^^ definition local 3$217974539
#  ^^ reference local 3$217974539
#     ^^^ reference [..] Array#map().
#           ^^ definition local 4$217974539
#           ^^ reference local 4$217974539
#              ^ reference [..] Integer#+().
#                ^^ reference local 4$217974539
   it.length
#  ^^ reference local 3$217974539
#     ^^^^^^ reference [..] Array#length().
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
#         ^^^^^ definition local 1$1798011293
     value.to_s
#    ^^^^^ reference local 1$1798011293
#          ^^^^ reference [..] Integer#to_s().
   end
#    ⌃ enclosing_range_end [..] ImplicitItPrecedence#it().
 
#  ⌄ enclosing_range_start [..] ImplicitItPrecedence#implicit_parameter().
   def implicit_parameter
#      ^^^^^^^^^^^^^^^^^^ definition [..] ImplicitItPrecedence#implicit_parameter().
     [1, 2].map { it + it }
#           ^^^ reference [..] Array#map().
#                 ^^ definition local 1$364763295
#                 ^^ reference local 1$364763295
#                    ^ reference [..] Integer#+().
#                      ^^ reference local 1$364763295
     [1, 2].map { it(it).upcase }
#           ^^^ reference [..] Array#map().
#                 ^^ reference [..] ImplicitItPrecedence#it().
#                    ^^ definition local 2$364763295
#                    ^^ reference local 2$364763295
#                        ^^^^^^ reference [..] String#upcase().
     [1, 2].map { self.it(it).upcase }
#           ^^^ reference [..] Array#map().
#                      ^^ reference [..] ImplicitItPrecedence#it().
#                         ^^ definition local 3$364763295
#                         ^^ reference local 3$364763295
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
#    ^^ definition local 1$284828581
     [1, 2].map { it.upcase }
#           ^^^ reference [..] Array#map().
#                 ^^ reference local 1$284828581
#                    ^^^^^^ reference [..] String#upcase().
     [1, 2].map { it(it.length).upcase }
#           ^^^ reference [..] Array#map().
#                 ^^ reference [..] ImplicitItPrecedence#it().
#                    ^^ reference local 1$284828581
#                       ^^^^^^ reference [..] String#length().
#                               ^^^^^^ reference [..] String#upcase().
     it.downcase
#    ^^ reference local 1$284828581
#       ^^^^^^^^ reference [..] String#downcase().
   end
#    ⌃ enclosing_range_end [..] ImplicitItPrecedence#existing_local().
 end
#  ⌃ enclosing_range_end [..] ImplicitItPrecedence#
