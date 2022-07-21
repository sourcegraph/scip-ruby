 # typed: true
 
 def f()
#^^^^^^^ definition [..] Object#f().
   T.let(true, T::Boolean)
#              ^ reference [..] T#
#                 ^^^^^^^ reference [..] T#Boolean.
 end
 
 module M
#       ^ definition [..] M#
   module_function
   sig { returns(T::Boolean) }
#  ^^^ reference [..] Sorbet#Private#Static#<Class:ResolvedSig>#sig().
#  ^^^ reference [..] Sorbet#Private#Static#<Class:ResolvedSig>#sig().
#                ^ reference [..] T#
#                   ^^^^^^^ reference [..] T#Boolean.
#                   ^^^^^^^ reference [..] T#Boolean.
#                   ^^^^^^^^^^ reference [..] Sorbet#Private#Static#ResolvedSig#
#                   ^^^^^^^^^^ reference [..] Sorbet#Private#Static#ResolvedSig#
   def b
#  ^^^^^ definition [..] M#b().
#  ^^^^^ definition [..] <Class:M>#b().
     true
   end
 end
