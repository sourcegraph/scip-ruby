 # typed: true
 
 def args(x, y)
#^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO args().
#         ^ definition local 1~#2634721084
#            ^ definition local 2~#2634721084
   z = x + y
#  ^ definition local 3~#2634721084
#      ^ reference local 1~#2634721084
#          ^ reference local 2~#2634721084
   if x == 2
#     ^ reference local 1~#2634721084
     z += y
#    ^ reference local 3~#2634721084
#    ^ reference (write) local 3~#2634721084
#         ^ reference local 2~#2634721084
   else
     z += x
#    ^ reference local 3~#2634721084
#    ^ reference (write) local 3~#2634721084
#         ^ reference local 1~#2634721084
   end
   z
#  ^ reference local 3~#2634721084
 end
