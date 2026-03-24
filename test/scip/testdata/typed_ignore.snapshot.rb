 # typed: ignore
 
 # `typed: ignore` files are parsed but not typechecked. This locks in what
 # (if anything) the indexer emits for such files.
 
#⌄ enclosing_range_start [..] IgnoredKlass#
 class IgnoredKlass
#      ^^^^^^^^^^^^ definition [..] IgnoredKlass#
#  ⌄ enclosing_range_start [..] IgnoredKlass#m().
   def m
#      ^ definition [..] IgnoredKlass#m().
     @field = 1
#    ^^^^^^ definition [..] IgnoredKlass#`@field`.
#    ^^^^^^^^^^ reference [..] IgnoredKlass#`@field`.
   end
#    ⌃ enclosing_range_end [..] IgnoredKlass#m().
 end
#  ⌃ enclosing_range_end [..] IgnoredKlass#
 
 IgnoredKlass.new.m
#^^^^^^^^^^^^ reference [..] IgnoredKlass#
#             ^^^ reference [..] Class#new().
#                 ^ reference [..] IgnoredKlass#m().
