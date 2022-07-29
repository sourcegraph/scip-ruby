 # typed: true
 
 class C1
#      ^^ definition [..] C1#
   extend T::Sig
#         ^ reference [..] T#
#            ^^^ reference [..] T#Sig#
 
   sig { returns(T::Boolean) }
#  ^^^ reference [..] Sorbet#Private#Static#<Class:ResolvedSig>#sig().
#        ^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#                ^ reference [..] T#
#                   ^^^^^^^ reference [..] T#Boolean.
#                   ^^^^^^^^^^ reference [..] Sorbet#Private#Static#ResolvedSig#
   def m1
#  ^^^^^^ definition [..] C1#m1().
     true
   end
 end
