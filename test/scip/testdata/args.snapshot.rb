 # typed: true
 
#⌄ enclosing_range_start [..] Object#args().
 def args(x, y)
#    ^^^^ definition [..] Object#args().
#         ^ definition local 1$2634721084
#            ^ definition local 2$2634721084
   z = x + y
#  ^ definition local 3$2634721084
#      ^ reference local 1$2634721084
#          ^ reference local 2$2634721084
   if x == 2
#     ^ reference local 1$2634721084
#       ^^ reference [..] BasicObject#`==`().
     z += y
#    ^ reference (write) local 3$2634721084
#    ^ reference local 3$2634721084
#         ^ reference local 2$2634721084
   else
     z += x
#    ^ reference (write) local 3$2634721084
#    ^ reference local 3$2634721084
#         ^ reference local 1$2634721084
   end
   z
#  ^ reference local 3$2634721084
 end
#  ⌃ enclosing_range_end [..] Object#args().
 
#⌄ enclosing_range_start [..] Object#keyword_args().
 def keyword_args(w:, x: 3, y: [], **kwargs)
#    ^^^^^^^^^^^^ definition [..] Object#keyword_args().
#                 ^^ definition local 1$3526982640
#                     ^^ definition local 2$3526982640
#                           ^^ definition local 3$3526982640
   y << w + x
#  ^ reference local 3$3526982640
#       ^ reference local 1$3526982640
#           ^ reference local 2$3526982640
   y << [a]
#  ^ reference local 3$3526982640
   return
 end
#  ⌃ enclosing_range_end [..] Object#keyword_args().
 
#⌄ enclosing_range_start [..] Object#use_kwargs().
 def use_kwargs
#    ^^^^^^^^^^ definition [..] Object#use_kwargs().
   h = { a: 3 }
#  ^ definition local 1$571973038
   keyword_args(w: 0, **h)
#  ^^^^^^^^^^^^ reference [..] Object#keyword_args().
#                       ^ reference local 1$571973038
   keyword_args(w: 0, x: 1, y: [2], **h)
#  ^^^^^^^^^^^^ reference [..] Object#keyword_args().
#                                     ^ reference local 1$571973038
   return
 end
#  ⌃ enclosing_range_end [..] Object#use_kwargs().
