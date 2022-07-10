 # typed: true
 
 def case(x, y)
#^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO case().
#^^^^^^^^^^^^ definition scip-ruby gem TODO TODO <static-init>().
#         ^ definition local 1~#2602907825
   case x
#       ^ reference local 1~#2602907825
     when 0
       x = 3
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
