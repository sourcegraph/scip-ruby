 # typed: true
 # check-errors: true
#⌄ enclosing_range_start [..] ReopenedMethod#
 class ReopenedMethod
#      ^^^^^^^^^^^^^^ definition [..] ReopenedMethod#
#  ⌄ enclosing_range_start [..] ReopenedMethod#value().
   def value
#      ^^^^^ definition [..] ReopenedMethod#value().
     2
   end
#    ⌃ enclosing_range_end [..] ReopenedMethod#value().
 end
#  ⌃ enclosing_range_end [..] ReopenedMethod#
 
 ReopenedMethod.new.value
#^^^^^^^^^^^^^^ reference [..] ReopenedMethod#
#               ^^^ reference [..] Class#new().
#                   ^^^^^ reference [..] ReopenedMethod#value().
