 # typed: true
 
 def arrays(a, i)
#^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO arrays().
#^^^^^^^^ definition scip-ruby gem TODO TODO <static-init>().
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
#  ^ definition local 4~#513334479
#      ^ reference local 1~#513334479
#        ^^^^^ reference scip-ruby gem TODO TODO <Magic>#
   a << a[-1]
#  ^ reference local 1~#513334479
#       ^ reference local 1~#513334479
 end
