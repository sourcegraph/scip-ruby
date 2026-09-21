 # typed: true
 
#⌄ enclosing_range_start [..] Object#arrays().
 def arrays(a, i)
#    ^^^^^^ definition [..] Object#arrays().
#           ^ definition local 1$1420173257
#              ^ definition local 2$1420173257
   a[0] = 0
#  ^ reference local 1$1420173257
   a[1] = a[2]
#  ^ reference local 1$1420173257
#         ^ reference local 1$1420173257
   a[i] = a[i + 1]
#  ^ reference local 1$1420173257
#    ^ reference local 2$1420173257
#         ^ reference local 1$1420173257
#           ^ reference local 2$1420173257
   b = a[2..-1]
#  ^ definition local 3$1420173257
#      ^ reference local 1$1420173257
   a << a[-1]
#  ^ reference local 1$1420173257
#       ^ reference local 1$1420173257
 end
#  ⌃ enclosing_range_end [..] Object#arrays().
