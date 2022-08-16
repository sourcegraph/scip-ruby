 # typed: true
 # options: showDocs
 
 module M
#       ^ definition [..] M#
#       documentation
#       | ```ruby
#       | module M
#       | ```
   extent T::Sig
#         ^ reference [..] T#
#            ^^^ reference [..] T#Sig#
 
   sig { params(x: Integer, y: String).returns(String) }
#  ^^^ reference [..] Sorbet#Private#<Class:Static>#sig().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#                  ^^^^^^^ reference [..] Integer#
#                              ^^^^^^ reference [..] String#
#                                              ^^^^^^ reference [..] String#
   def js_add(x, y)
#  ^^^^^^^^^^^^^^^^ definition [..] M#js_add().
#  documentation
#  | ```ruby
#  | sig {params(x: Integer, y: String).returns(String)}
#  | def js_add(x, y)
#  | ```
#             ^ definition local 1~#1239553962
#             documentation
#             | ```ruby
#             | x (Integer)
#             | ```
#                ^ definition local 2~#1239553962
#                documentation
#                | ```ruby
#                | y (String)
#                | ```
     xs = x.to_s
#    ^^ definition local 3~#1239553962
#    documentation
#    | ```ruby
#    | xs (String)
#    | ```
#         ^ reference local 1~#1239553962
#           ^^^^ reference [..] Integer#to_s().
     ret = xs + y
#    ^^^ definition local 4~#1239553962
#    documentation
#    | ```ruby
#    | ret (String)
#    | ```
#          ^^ reference local 3~#1239553962
#             ^ reference [..] String#+().
#               ^ reference local 2~#1239553962
     return ret
#    ^^^^^^^^^^ reference local 4~#1239553962
#    override_documentation
#    | ```ruby
#    | return ret (T.noreturn)
#    | ```
   end
 end
