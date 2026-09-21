 # typed: strict
 # parser: prism
 # enable-experimental-rbs-comments: true
 
#⌄ enclosing_range_start [..] RBSValidation#
 class RBSValidation
#      ^^^^^^^^^^^^^ definition [..] RBSValidation#
   #: -> String
#        ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] RBSValidation#title().
   def title
#      ^^^^^ definition [..] RBSValidation#title().
     123 # error: Expected `String` but found `Integer(123)` for method result type
   end
#    ⌃ enclosing_range_end [..] RBSValidation#title().
 end
#  ⌃ enclosing_range_end [..] RBSValidation#
