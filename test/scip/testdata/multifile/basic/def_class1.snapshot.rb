 # typed: true
 
#⌄ enclosing_range_start [..] C1#
 class C1
#      ^^ definition [..] C1#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { returns(T::Boolean) }
#                   ^^^^^^^ reference [..] T#Boolean.
#  ⌄ enclosing_range_start [..] C1#m1().
   def m1
#      ^^ definition [..] C1#m1().
     true
   end
#    ⌃ enclosing_range_end [..] C1#m1().
 end
#  ⌃ enclosing_range_end [..] C1#
