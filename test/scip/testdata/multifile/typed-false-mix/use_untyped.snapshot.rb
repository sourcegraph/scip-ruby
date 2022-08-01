 # typed: true
 
 require 'def_untyped'
 
 module N
#       ^ definition [..] N#
   class D < C
#        ^ definition [..] N#D#
#            ^ reference [..] C#
   end
 end
