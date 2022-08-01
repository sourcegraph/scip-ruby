 # typed: true
 
 class D
#      ^ definition [..] D#
 end
 
 class C < ::D
#      ^ definition [..] C#
#            ^ definition [..] D#
 end
