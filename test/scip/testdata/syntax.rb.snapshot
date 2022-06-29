 # typed: true
 
 _ = 0 # stub for global <static-init>
#^ definition local 1~#119448696
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO <static-init>().
 
 def globalFn1()
#^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO globalFn1().
   x = 10
#  ^ definition local 1~#3846536873
   x
#  ^ reference local 1~#3846536873
 end
 
 def globalFn2()
#^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO globalFn2().
   x = globalFn1()
#  ^ definition local 1~#3796204016
#  ^^^^^^^^^^^^^^^ reference local 1~#3796204016
#      ^^^^^^^^^ reference scip-ruby gem TODO TODO globalFn1().
 end
 
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
#    ^ reference (write) local 3~#2634721084
#    ^ reference local 3~#2634721084
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
 
 def arrays(a, i)
#^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO arrays().
#           ^ definition local 1~#513334479
#              ^ definition local 2~#513334479
   a[0] = 0
#  ^ reference local 1~#513334479
   a[1] = a[2]
#  ^ reference local 1~#513334479
#         ^ reference local 1~#513334479
   a[i] = a[i + 1]
#  ^ reference local 1~#513334479
#    ^ reference local 2~#513334479
#         ^ reference local 1~#513334479
#           ^ reference local 2~#513334479
   b = a[2..-1]
#  ^ definition local 3~#513334479
#      ^ reference local 1~#513334479
   a << a[-1]
#  ^ reference local 1~#513334479
#       ^ reference local 1~#513334479
 end
 
 def hashes(h, k)
#^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO hashes().
#           ^ definition local 1~#1685166589
#              ^ definition local 2~#1685166589
   h["hello"] = "world"
#  ^ reference local 1~#1685166589
   old = h["world"]
#  ^^^ definition local 3~#1685166589
#        ^ reference local 1~#1685166589
   h[k] = h[old]
#  ^ reference local 1~#1685166589
#    ^ reference local 2~#1685166589
#         ^ reference local 1~#1685166589
#           ^^^ reference local 3~#1685166589
 end
