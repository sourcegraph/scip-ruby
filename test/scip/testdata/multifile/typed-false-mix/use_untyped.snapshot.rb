 # typed: true
 
 require 'def_untyped'
#^^^^^^^ reference [..] Kernel#require().
 
 module N
#       ^ definition [..] N#
   class D < C
#        ^ definition [..] N#D#
#            ^ reference [..] C#
   end
 end
