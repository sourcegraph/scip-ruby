 # typed: true
 
#⌄ enclosing_range_start [..] D#
 class D
#      ^ definition [..] D#
 end
#  ⌃ enclosing_range_end [..] D#
 
#⌄ enclosing_range_start [..] C#
 class C < ::D
#      ^ definition [..] C#
#            ^ reference [..] D#
 end
#  ⌃ enclosing_range_end [..] C#
