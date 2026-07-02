 # typed: false
 
#⌄ enclosing_range_start [..] C#
 class C
#      ^ definition [..] C#
#  ⌄ enclosing_range_start [..] C#f().
   def f
#      ^ definition [..] C#f().
     @f = 0
#    ^^ definition [..] C#`@f`.
#    ^^^^^^ reference [..] C#`@f`.
   end
#    ⌃ enclosing_range_end [..] C#f().
 
#  ⌄ enclosing_range_start [..] C#g().
   def g(x)
#      ^ definition [..] C#g().
#        ^ definition local 1$3792446982
     x + @f + f
#    ^ reference local 1$3792446982
#        ^^ reference [..] C#`@f`.
#             ^ reference [..] C#f().
   end
#    ⌃ enclosing_range_end [..] C#g().
 end
#  ⌃ enclosing_range_end [..] C#
