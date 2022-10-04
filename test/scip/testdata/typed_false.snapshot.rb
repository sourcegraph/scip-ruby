 # typed: false
 
 class C
#      ^ definition [..] C#
   def f
#      ^ definition [..] C#f().
     @f = 0
#    ^^ definition [..] C#`@f`.
#    ^^^^^^ reference [..] C#`@f`.
   end
 
   def g(x)
#      ^ definition [..] C#g().
#        ^ definition local 1~#3792446982
     x + @f + f
#    ^ reference local 1~#3792446982
#        ^^ reference [..] C#`@f`.
#             ^ reference [..] C#f().
   end
 end
