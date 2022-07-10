 # typed: true
 
 def if_elsif_else()
#^^^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO if_elsif_else().
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO <static-init>().
   x = 0
#  ^ definition local 1~#2393773952
   y = 0
#  ^ definition local 2~#2393773952
   # Basic stuff
   if x == 1
#     ^ reference local 1~#2393773952
     y = 2
#    ^ reference (write) local 2~#2393773952
   elsif x == 2
#        ^ reference local 1~#2393773952
     y = 3
#    ^ reference (write) local 2~#2393773952
   else
     y = x
#    ^ reference (write) local 2~#2393773952
#        ^ reference local 1~#2393773952
   end
 
   # More complex expressiosn
   z =
#  ^ definition local 3~#2393773952
     if if x == 0 then x+1 else x+2 end == 1
#          ^ reference local 1~#2393773952
#                      ^ reference local 1~#2393773952
#                               ^ reference local 1~#2393773952
       x
#      ^ reference local 1~#2393773952
     else
       x+1
#      ^ reference local 1~#2393773952
     end
   z = z if z != 10
#  ^ reference (write) local 3~#2393773952
#      ^ reference local 3~#2393773952
#           ^ reference local 3~#2393773952
 
   return
 end
 
 def unless()
#^^^^^^^^^^^^ definition scip-ruby gem TODO TODO unless().
   z = 0
#  ^ definition local 1~#2827997891
   x = 1
#  ^ definition local 2~#2827997891
   unless z == 9
#         ^ reference local 1~#2827997891
     z = 9
#    ^ reference (write) local 1~#2827997891
   end
 
   unless x == 10
#         ^ reference local 2~#2827997891
     x = 3
#    ^ reference (write) local 2~#2827997891
   else
     x = 2
#    ^ reference (write) local 2~#2827997891
   end
   return
 end
 
 def case(x, y)
#^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO case().
#         ^ definition local 1~#2602907825
#            ^ definition local 2~#2602907825
   case x
#       ^ reference local 1~#2602907825
     when 0
       x = 3
#      ^ reference (write) local 1~#2602907825
     when y
#         ^ reference local 2~#2602907825
       x = 2
#      ^ reference (write) local 1~#2602907825
     when (3 == (x = 1))
#                ^ reference (write) local 1~#2602907825
#                ^^^^^ reference local 1~#2602907825
       x = 0
#      ^ reference (write) local 1~#2602907825
     else
       x = 1
#      ^ reference (write) local 1~#2602907825
   end
   return
 end
 
 def for(xs)
#^^^^^^^^^^^ definition scip-ruby gem TODO TODO for().
#        ^^ definition local 1~#2901640080
   for e in xs
#      ^ definition local 2~#2901640080
#           ^^ reference local 1~#2901640080
     puts e
#         ^ reference local 2~#2901640080
   end
 
   for f in xs
#      ^ definition local 3~#2901640080
#           ^^ reference local 1~#2901640080
     g = f+1
#    ^ definition local 4~#2901640080
#        ^ reference local 3~#2901640080
     next if g == 0
#            ^ reference local 4~#2901640080
     next g+1 if g == 1
#         ^ reference local 4~#2901640080
#                ^ reference local 4~#2901640080
     break if g == 2
#             ^ reference local 4~#2901640080
     break g+1 if g == 3
#          ^ reference local 4~#2901640080
#                 ^ reference local 4~#2901640080
     # NOTE: redo is unsupported (https://srb.help/3003)
     # but emitting a reference here does work
     redo if g == 4
#            ^ reference local 4~#2901640080
   end
 end
 
 def while(xs)
#^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO while().
#          ^^ definition local 1~#231090382
   i = 0
#  ^ definition local 2~#231090382
   while i < 10
#        ^ reference local 2~#231090382
     puts xs[i]
#         ^^ reference local 1~#231090382
#            ^ reference local 2~#231090382
   end
 
   j = 0
#  ^ definition local 3~#231090382
   while j < 10
#        ^ reference local 3~#231090382
     g = xs[j]
#    ^ definition local 4~#231090382
#        ^^ reference local 1~#231090382
#           ^ reference local 3~#231090382
     next if g == 0
#            ^ reference local 4~#231090382
     next g+1 if g == 1
#         ^ reference local 4~#231090382
#                ^ reference local 4~#231090382
     break if g == 2
#             ^ reference local 4~#231090382
     break g+1 if g == 3
#          ^ reference local 4~#231090382
#                 ^ reference local 4~#231090382
     # NOTE: redo is unsupported (https://srb.help/3003)
     # but emitting a reference here does work
     redo if g == 4
#            ^ reference local 4~#231090382
   end
 end
 
 def until(xs)
#^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO until().
#          ^^ definition local 1~#3132432719
   i = 0
#  ^ definition local 2~#3132432719
   until i > 10
#        ^ reference local 2~#3132432719
     puts xs[i]
#         ^^ reference local 1~#3132432719
#            ^ reference local 2~#3132432719
   end
 
   j = 0
#  ^ definition local 3~#3132432719
   until j > 10
#        ^ reference local 3~#3132432719
     g = xs[j]
#    ^ definition local 4~#3132432719
#        ^^ reference local 1~#3132432719
#           ^ reference local 3~#3132432719
     next if g == 0
#            ^ reference local 4~#3132432719
     next g+1 if g == 1
#         ^ reference local 4~#3132432719
#                ^ reference local 4~#3132432719
     break if g == 2
#             ^ reference local 4~#3132432719
     break g+1 if g == 3
#          ^ reference local 4~#3132432719
#                 ^ reference local 4~#3132432719
     # NOTE: redo is unsupported (https://srb.help/3003)
     # but emitting a reference here does work
     redo if g == 4
#            ^ reference local 4~#3132432719
   end
 end
 
 def flip_flop(xs)
#^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO flip_flop().
#              ^^ definition local 1~#2191960030
   # NOTE: flip-flops are unsupported (https://srb.help/3003)
   # Unlike redo, which somehow works, we fail to emit references
   # for the conditions.
   # Keep this test anyways to check that we don't crash/mess something up
   for x in xs
#      ^ definition local 2~#2191960030
#           ^^ reference local 1~#2191960030
     puts x if x==2..x==8
#         ^ reference local 2~#2191960030
     puts x+1 if x==4...x==6
#         ^ reference local 2~#2191960030
   end
 end
