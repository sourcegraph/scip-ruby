 # typed: true
 
 def f()
#^^^^^^^ definition scip-ruby gem TODO TODO Object#f().
   T.let(true, T::Boolean)
#              ^ reference scip-ruby gem TODO TODO T#
#                 ^^^^^^^ reference scip-ruby gem TODO TODO T#Boolean.
 end
 
 module M
#       ^ definition scip-ruby gem TODO TODO M#
   module_function
   sig { returns(T::Boolean) }
#  ^^^ reference scip-ruby gem TODO TODO Sorbet#Private#Static#<Class:ResolvedSig>#sig().
#  ^^^ reference scip-ruby gem TODO TODO Sorbet#Private#Static#<Class:ResolvedSig>#sig().
#                ^ reference scip-ruby gem TODO TODO T#
#                   ^^^^^^^ reference scip-ruby gem TODO TODO T#Boolean.
#                   ^^^^^^^ reference scip-ruby gem TODO TODO T#Boolean.
#                   ^^^^^^^^^^ reference scip-ruby gem TODO TODO Sorbet#Private#Static#ResolvedSig#
#                   ^^^^^^^^^^ reference scip-ruby gem TODO TODO Sorbet#Private#Static#ResolvedSig#
   def b
#  ^^^^^ definition scip-ruby gem TODO TODO M#b().
#  ^^^^^ definition scip-ruby gem TODO TODO <Class:M>#b().
     true
   end
 end
