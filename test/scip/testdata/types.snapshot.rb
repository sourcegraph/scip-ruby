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
#  ^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#  ^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#                ^ reference [..] T#
#                   ^^^^^^^ reference [..] T#Boolean.
#                   ^^^^^^^ reference [..] T#Boolean.
#                   ^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#                   ^^^^^^^^^^ reference [..] Sorbet#Private#Static#
   def b
#  ^^^^^ definition [..] M#b().
#  ^^^^^ definition [..] `<Class:M>`#b().
     true
   end
 end
