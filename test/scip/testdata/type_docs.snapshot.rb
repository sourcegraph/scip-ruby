 # typed: true
 # options: showDocs
 
#⌄ enclosing_range_start [..] M#
 module M
#       ^ definition [..] M#
#       documentation
#       | ```ruby
#       | module M
#       | ```
   extent T::Sig
 
   sig { params(x: Integer, y: String).returns(String) }
#                  ^^^^^^^ reference [..] Integer#
#                              ^^^^^^ reference [..] String#
#                                              ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] M#js_add().
   def js_add(x, y)
#      ^^^^^^ definition [..] M#js_add().
#      documentation
#      | ```ruby
#      | sig { params(x: Integer, y: String).returns(String) }
#      | def js_add(x, y)
#      | ```
#             ^ definition local 1$194175550
#             documentation
#             | ```ruby
#             | x (Integer)
#             | ```
#                ^ definition local 2$194175550
#                documentation
#                | ```ruby
#                | y (String)
#                | ```
     xs = x.to_s
#    ^^ definition local 3$194175550
#    documentation
#    | ```ruby
#    | xs (String)
#    | ```
#         ^ reference local 1$194175550
#           ^^^^ reference [..] Integer#to_s().
     ret = xs + y
#    ^^^ definition local 4$194175550
#    documentation
#    | ```ruby
#    | ret (String)
#    | ```
#          ^^ reference local 3$194175550
#             ^ reference [..] String#+().
#               ^ reference local 2$194175550
     return ret
#           ^^^ reference local 4$194175550
   end
#    ⌃ enclosing_range_end [..] M#js_add().
 end
#  ⌃ enclosing_range_end [..] M#
