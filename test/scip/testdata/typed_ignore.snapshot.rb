 # typed: ignore
 
 # `typed: ignore` files are parsed but not typechecked. This locks in what
 # (if anything) the indexer emits for such files.
 
 class IgnoredKlass
#      ^^^^^^^^^^^^ definition [..] IgnoredKlass#
   def m
#      ^ definition [..] IgnoredKlass#m().
     @field = 1
#    ^^^^^^ definition [..] IgnoredKlass#`@field`.
#    ^^^^^^^^^^ reference [..] IgnoredKlass#`@field`.
   end
 end
 
 IgnoredKlass.new.m
#^^^^^^^^^^^^ reference [..] IgnoredKlass#
#             ^^^ reference [..] Class#new().
#                 ^ reference [..] IgnoredKlass#m().
