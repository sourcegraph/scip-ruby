 # typed: true
 
 def if_elsif_else()
#^^^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO if_elsif_else().
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO <static-init>().
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
     redo if g == 4
#            ^ reference local 4~#2901640080
   end
 end
