 # typed: true
 
 class C1
#      ^^ definition [..] C1#
   extend T::Sig
 
   sig { returns(T::Boolean) }
#                   ^^^^^^^ reference [..] T#Boolean.
   def m1
#      ^^ definition [..] C1#m1().
     true
   end
 end
