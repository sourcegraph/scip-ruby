 # typed: true
 
#⌄ enclosing_range_start [..] Object#if_elsif_else().
 def if_elsif_else()
#    ^^^^^^^^^^^^^ definition [..] Object#if_elsif_else().
   x = 0
#  ^ definition local 1$818143658
   y = 0
#  ^ definition local 2$818143658
   # Basic stuff
   if x == 1
#     ^ reference local 1$818143658
#       ^^ reference [..] Integer#`==`().
     y = 2
#    ^ reference (write) local 2$818143658
   elsif x == 2
#        ^ reference local 1$818143658
#          ^^ reference [..] Integer#`==`().
     y = 3
#    ^ reference (write) local 2$818143658
   else
     y = x
#    ^ reference (write) local 2$818143658
#        ^ reference local 1$818143658
   end
 
   # More complex expressiosn
   z =
#  ^ definition local 3$818143658
     if if x == 0 then x+1 else x+2 end == 1
#          ^ reference local 1$818143658
#            ^^ reference [..] Integer#`==`().
#                      ^ reference local 1$818143658
#                       ^ reference [..] Integer#+().
#                               ^ reference local 1$818143658
#                                ^ reference [..] Integer#+().
#                                       ^^ reference [..] Integer#`==`().
       x
#      ^ reference local 1$818143658
     else
       x+1
#      ^ reference local 1$818143658
#       ^ reference [..] Integer#+().
     end
   z = z if z != 10
#  ^ reference (write) local 3$818143658
#      ^ reference local 3$818143658
#           ^ reference local 3$818143658
#             ^^ reference [..] BasicObject#`!=`().
 
   return
 end
#  ⌃ enclosing_range_end [..] Object#if_elsif_else().
 
#⌄ enclosing_range_start [..] Object#unless().
 def unless()
#    ^^^^^^ definition [..] Object#unless().
   z = 0
#  ^ definition local 1$916274629
   x = 1
#  ^ definition local 2$916274629
   unless z == 9
#         ^ reference local 1$916274629
#           ^^ reference [..] Integer#`==`().
     z = 9
#    ^ reference (write) local 1$916274629
   end
 
   unless x == 10
#         ^ reference local 2$916274629
#           ^^ reference [..] Integer#`==`().
     x = 3
#    ^ reference (write) local 2$916274629
   else
     x = 2
#    ^ reference (write) local 2$916274629
   end
   return
 end
#  ⌃ enclosing_range_end [..] Object#unless().
 
#⌄ enclosing_range_start [..] Object#case().
 def case(x, y)
#    ^^^^ definition [..] Object#case().
#         ^ definition local 1$2888793159
#            ^ definition local 2$2888793159
   case x
#       ^ reference local 1$2888793159
     when 0
       x = 3
#      ^ reference (write) local 1$2888793159
     when y
#         ^ reference local 2$2888793159
       x = 2
#      ^ reference (write) local 1$2888793159
     when (3 == (x = 1))
#            ^^ reference [..] Integer#`==`().
#                ^ reference (write) local 1$2888793159
#                ^^^^^ reference local 1$2888793159
       x = 0
#      ^ reference (write) local 1$2888793159
     else
       x = 1
#      ^ reference (write) local 1$2888793159
   end
   return
 end
#  ⌃ enclosing_range_end [..] Object#case().
 
#⌄ enclosing_range_start [..] Object#for().
 def for(xs)
#    ^^^ definition [..] Object#for().
#        ^^ definition local 1$1772972878
   for e in xs
#      ^ definition local 2$1772972878
#           ^^ reference local 1$1772972878
     puts e
#    ^^^^ reference [..] Kernel#puts().
#         ^ reference local 2$1772972878
   end
 
   for f in xs
#      ^ definition local 3$1772972878
#           ^^ reference local 1$1772972878
     g = f+1
#    ^ definition local 4$1772972878
#        ^ reference local 3$1772972878
     next if g == 0
#            ^ reference local 4$1772972878
#              ^^ reference [..] BasicObject#`==`().
     next g+1 if g == 1
#         ^ reference local 4$1772972878
#          ^ reference [..] Integer#+().
#                ^ reference local 4$1772972878
#                  ^^ reference [..] BasicObject#`==`().
     break if g == 2
#             ^ reference local 4$1772972878
#               ^^ reference [..] BasicObject#`==`().
     break g+1 if g == 3
#          ^ reference local 4$1772972878
#           ^ reference [..] Integer#+().
#                 ^ reference local 4$1772972878
#                   ^^ reference [..] BasicObject#`==`().
     # NOTE: redo is unsupported (https://srb.help/3003)
     # but emitting a reference here does work
     redo if g == 4
#            ^ reference local 4$1772972878
#              ^^ reference [..] BasicObject#`==`().
   end
 end
#  ⌃ enclosing_range_end [..] Object#for().
 
#⌄ enclosing_range_start [..] Object#while().
 def while(xs)
#    ^^^^^ definition [..] Object#while().
#          ^^ definition local 1$2612970332
   i = 0
#  ^ definition local 2$2612970332
   while i < 10
#        ^ reference local 2$2612970332
#          ^ reference [..] Integer#`<`().
     puts xs[i]
#    ^^^^ reference [..] Kernel#puts().
#         ^^ reference local 1$2612970332
#            ^ reference local 2$2612970332
   end
 
   j = 0
#  ^ definition local 3$2612970332
   while j < 10
#        ^ reference local 3$2612970332
#          ^ reference [..] Integer#`<`().
     g = xs[j]
#    ^ definition local 4$2612970332
#        ^^ reference local 1$2612970332
#           ^ reference local 3$2612970332
     next if g == 0
#            ^ reference local 4$2612970332
#              ^^ reference [..] BasicObject#`==`().
     next g+1 if g == 1
#         ^ reference local 4$2612970332
#          ^ reference [..] Integer#+().
#                ^ reference local 4$2612970332
#                  ^^ reference [..] BasicObject#`==`().
     break if g == 2
#             ^ reference local 4$2612970332
#               ^^ reference [..] BasicObject#`==`().
     break g+1 if g == 3
#          ^ reference local 4$2612970332
#           ^ reference [..] Integer#+().
#                 ^ reference local 4$2612970332
#                   ^^ reference [..] BasicObject#`==`().
     # NOTE: redo is unsupported (https://srb.help/3003)
     # but emitting a reference here does work
     redo if g == 4
#            ^ reference local 4$2612970332
#              ^^ reference [..] BasicObject#`==`().
   end
 end
#  ⌃ enclosing_range_end [..] Object#while().
 
#⌄ enclosing_range_start [..] Object#until().
 def until(xs)
#    ^^^^^ definition [..] Object#until().
#          ^^ definition local 1$3270743773
   i = 0
#  ^ definition local 2$3270743773
   until i > 10
#        ^ reference local 2$3270743773
#          ^ reference [..] Integer#`>`().
     puts xs[i]
#    ^^^^ reference [..] Kernel#puts().
#         ^^ reference local 1$3270743773
#            ^ reference local 2$3270743773
   end
 
   j = 0
#  ^ definition local 3$3270743773
   until j > 10
#        ^ reference local 3$3270743773
#          ^ reference [..] Integer#`>`().
     g = xs[j]
#    ^ definition local 4$3270743773
#        ^^ reference local 1$3270743773
#           ^ reference local 3$3270743773
     next if g == 0
#            ^ reference local 4$3270743773
#              ^^ reference [..] BasicObject#`==`().
     next g+1 if g == 1
#         ^ reference local 4$3270743773
#          ^ reference [..] Integer#+().
#                ^ reference local 4$3270743773
#                  ^^ reference [..] BasicObject#`==`().
     break if g == 2
#             ^ reference local 4$3270743773
#               ^^ reference [..] BasicObject#`==`().
     break g+1 if g == 3
#          ^ reference local 4$3270743773
#           ^ reference [..] Integer#+().
#                 ^ reference local 4$3270743773
#                   ^^ reference [..] BasicObject#`==`().
     # NOTE: redo is unsupported (https://srb.help/3003)
     # but emitting a reference here does work
     redo if g == 4
#            ^ reference local 4$3270743773
#              ^^ reference [..] BasicObject#`==`().
   end
 end
#  ⌃ enclosing_range_end [..] Object#until().
 
#⌄ enclosing_range_start [..] Object#flip_flop().
 def flip_flop(xs)
#    ^^^^^^^^^ definition [..] Object#flip_flop().
#              ^^ definition local 1$2138084944
   # NOTE: flip-flops are unsupported (https://srb.help/3003)
   # Unlike redo, which somehow works, we fail to emit references
   # for the conditions.
   # Keep this test anyways to check that we don't crash/mess something up
   for x in xs
#      ^ definition local 2$2138084944
#           ^^ reference local 1$2138084944
     puts x if x==2..x==8
#    ^^^^ reference [..] Kernel#puts().
#         ^ reference local 2$2138084944
     puts x+1 if x==4...x==6
#    ^^^^ reference [..] Kernel#puts().
#         ^ reference local 2$2138084944
   end
 end
#  ⌃ enclosing_range_end [..] Object#flip_flop().
