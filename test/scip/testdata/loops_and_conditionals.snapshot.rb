 # typed: true
 
 def if_elsif_else()
#^^^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO if_elsif_else().
#^^^^^^^^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO <static-init>().
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
