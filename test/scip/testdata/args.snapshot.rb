 # typed: true
 
#⌄ enclosing_range_start [..] Object#args().
 def args(x, y)
#    ^^^^ definition [..] Object#args().
#         ^ definition local 1$3240385342
#            ^ definition local 2$3240385342
   z = x + y
#  ^ definition local 3$3240385342
#      ^ reference local 1$3240385342
#          ^ reference local 2$3240385342
   if x == 2
#     ^ reference local 1$3240385342
#       ^^ reference [..] BasicObject#`==`().
     z += y
#    ^ reference (write) local 3$3240385342
#    ^ reference local 3$3240385342
#         ^ reference local 2$3240385342
   else
     z += x
#    ^ reference (write) local 3$3240385342
#    ^ reference local 3$3240385342
#         ^ reference local 1$3240385342
   end
   z
#  ^ reference local 3$3240385342
 end
#  ⌃ enclosing_range_end [..] Object#args().
 
#⌄ enclosing_range_start [..] Object#keyword_args().
 def keyword_args(w:, x: 3, y: [], **kwargs)
#    ^^^^^^^^^^^^ definition [..] Object#keyword_args().
#                 ^^ definition local 1$3994954926
#                     ^^ definition local 2$3994954926
#                           ^^ definition local 3$3994954926
   y << w + x
#  ^ reference local 3$3994954926
#       ^ reference local 1$3994954926
#           ^ reference local 2$3994954926
   y << [a]
#  ^ reference local 3$3994954926
   return
 end
#  ⌃ enclosing_range_end [..] Object#keyword_args().
 
#⌄ enclosing_range_start [..] Object#use_kwargs().
 def use_kwargs
#    ^^^^^^^^^^ definition [..] Object#use_kwargs().
   h = { a: 3 }
#  ^ definition local 1$3752200432
   keyword_args(w: 0, **h)
#  ^^^^^^^^^^^^ reference [..] Object#keyword_args().
#                       ^ reference local 1$3752200432
   keyword_args(w: 0, x: 1, y: [2], **h)
#  ^^^^^^^^^^^^ reference [..] Object#keyword_args().
#                                     ^ reference local 1$3752200432
   return
 end
#  ⌃ enclosing_range_end [..] Object#use_kwargs().
