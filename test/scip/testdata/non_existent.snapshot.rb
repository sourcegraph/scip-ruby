 # typed: true
 
 class D
#      ^ definition [..] D#
 end
 
 class C < ::D
#      ^ definition [..] C#
#            ^ reference [..] D#
 end
