 # typed: true
 
#⌄ enclosing_range_start [..] Object#for_loop().
 def for_loop()
#    ^^^^^^^^ definition [..] Object#for_loop().
   y = 0
#  ^ definition local 1$1120785331
   for x in [1, 2, 3]
#      ^ definition local 2$1120785331
     y += x
#    ^ reference (write) local 1$1120785331
#    ^ reference local 1$1120785331
#         ^ reference local 2$1120785331
     for x in [3, 4, 5]
#        ^ definition local 3$1120785331
       y += x
#      ^ reference (write) local 1$1120785331
#      ^ reference local 1$1120785331
#      ^^^^^^ reference local 1$1120785331
#        ^^ reference [..] Integer#+().
#           ^ reference local 3$1120785331
     end
   end
   y
#  ^ reference local 1$1120785331
 end
#  ⌃ enclosing_range_end [..] Object#for_loop().
