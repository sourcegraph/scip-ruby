 # typed: true
 
 class C1
#      ^^ definition [..] C1#
   def m1
#      ^^ definition [..] C1#m1().
   end
 
   def m2
#      ^^ definition [..] C1#m2().
   end
 end
 
 class C2 < C1
#      ^^ definition [..] C2#
#           ^^ definition [..] C1#
   def m2
#      ^^ definition [..] C2#m2().
   end
   def m3
#      ^^ definition [..] C2#m3().
     m1
     m2
#    ^^ reference [..] C2#m2().
   end
 end
