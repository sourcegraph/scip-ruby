 # typed: true
 
 require 'def_untyped'
#^^^^^^^ reference [..] Kernel#require().
 
#⌄ enclosing_range_start [..] N#
 module N
#       ^ definition [..] N#
#  ⌄ enclosing_range_start [..] N#D#
   class D < C
#        ^ definition [..] N#D#
#            ^ reference [..] C#
   end
#    ⌃ enclosing_range_end [..] N#D#
 end
#  ⌃ enclosing_range_end [..] N#
