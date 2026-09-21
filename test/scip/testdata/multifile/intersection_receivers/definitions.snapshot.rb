 # typed: true
 # check-errors: true
 
#⌄ enclosing_range_start [..] CrossIntersectionLeft#
 module CrossIntersectionLeft
#       ^^^^^^^^^^^^^^^^^^^^^ definition [..] CrossIntersectionLeft#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   sig { returns(String) }
#                ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] CrossIntersectionLeft#left().
   def left
#      ^^^^ definition [..] CrossIntersectionLeft#left().
     "left"
   end
#    ⌃ enclosing_range_end [..] CrossIntersectionLeft#left().
 end
#  ⌃ enclosing_range_end [..] CrossIntersectionLeft#
 
#⌄ enclosing_range_start [..] CrossIntersectionRight#
 module CrossIntersectionRight
#       ^^^^^^^^^^^^^^^^^^^^^^ definition [..] CrossIntersectionRight#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   sig { returns(String) }
#                ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] CrossIntersectionRight#right().
   def right
#      ^^^^^ definition [..] CrossIntersectionRight#right().
     "right"
   end
#    ⌃ enclosing_range_end [..] CrossIntersectionRight#right().
 end
#  ⌃ enclosing_range_end [..] CrossIntersectionRight#
