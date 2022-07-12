 # typed: true
 
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
