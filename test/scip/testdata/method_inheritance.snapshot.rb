 # typed: true
 
#⌄ enclosing_range_start [..] C1#
 class C1
#      ^^ definition [..] C1#
#  ⌄ enclosing_range_start [..] C1#m1().
   def m1
#      ^^ definition [..] C1#m1().
   end
#    ⌃ enclosing_range_end [..] C1#m1().
 
#  ⌄ enclosing_range_start [..] C1#m2().
   def m2
#      ^^ definition [..] C1#m2().
   end
#    ⌃ enclosing_range_end [..] C1#m2().
 end
#  ⌃ enclosing_range_end [..] C1#
 
#⌄ enclosing_range_start [..] C2#
 class C2 < C1
#      ^^ definition [..] C2#
#           ^^ reference [..] C1#
#  ⌄ enclosing_range_start [..] C2#m2().
   def m2
#      ^^ definition [..] C2#m2().
   end
#    ⌃ enclosing_range_end [..] C2#m2().
#  ⌄ enclosing_range_start [..] C2#m3().
   def m3
#      ^^ definition [..] C2#m3().
     m1
#    ^^ reference [..] C1#m1().
     m2
#    ^^ reference [..] C2#m2().
   end
#    ⌃ enclosing_range_end [..] C2#m3().
 end
#  ⌃ enclosing_range_end [..] C2#
 
#⌄ enclosing_range_start [..] C3#
 class C3 < C2
#      ^^ definition [..] C3#
#           ^^ reference [..] C2#
#  ⌄ enclosing_range_start [..] C3#m4().
   def m4
#      ^^ definition [..] C3#m4().
     m1
#    ^^ reference [..] C1#m1().
   end
#    ⌃ enclosing_range_end [..] C3#m4().
 end
#  ⌃ enclosing_range_end [..] C3#
