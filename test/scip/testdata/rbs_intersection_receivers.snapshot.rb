 # typed: true
 # enable-experimental-rbs-comments: true
 
#⌄ enclosing_range_start [..] RBSIntersectionLeft#
 module RBSIntersectionLeft
#       ^^^^^^^^^^^^^^^^^^^ definition [..] RBSIntersectionLeft#
   #: -> String
#        ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] RBSIntersectionLeft#left().
   def left
#      ^^^^ definition [..] RBSIntersectionLeft#left().
     "left"
   end
#    ⌃ enclosing_range_end [..] RBSIntersectionLeft#left().
 end
#  ⌃ enclosing_range_end [..] RBSIntersectionLeft#
 
#⌄ enclosing_range_start [..] RBSIntersectionRight#
 module RBSIntersectionRight
#       ^^^^^^^^^^^^^^^^^^^^ definition [..] RBSIntersectionRight#
   #: -> String
#        ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] RBSIntersectionRight#right().
   def right
#      ^^^^^ definition [..] RBSIntersectionRight#right().
     "right"
   end
#    ⌃ enclosing_range_end [..] RBSIntersectionRight#right().
 end
#  ⌃ enclosing_range_end [..] RBSIntersectionRight#
 
 #: (RBSIntersectionLeft & RBSIntersectionRight) -> void
#    ^^^^^^^^^^^^^^^^^^^ reference [..] RBSIntersectionLeft#
#                          ^^^^^^^^^^^^^^^^^^^^ reference [..] RBSIntersectionRight#
#⌄ enclosing_range_start [..] Object#rbs_intersection().
 def rbs_intersection(value)
#    ^^^^^^^^^^^^^^^^ definition [..] Object#rbs_intersection().
#                     ^^^^^ definition local 1$342360874
   value.left.upcase
#  ^^^^^ reference local 1$342360874
#        ^^^^ reference [..] RBSIntersectionLeft#left().
#             ^^^^^^ reference [..] String#upcase().
   value.right.upcase
#  ^^^^^ reference local 1$342360874
#        ^^^^^ reference [..] RBSIntersectionRight#right().
#              ^^^^^^ reference [..] String#upcase().
 end
#  ⌃ enclosing_range_end [..] Object#rbs_intersection().
