 # typed: true
 
 def f()
#^^^^^^^ definition scip-ruby gem TODO TODO Object#f().
   T.let(true, T::Boolean)
#              ^ reference scip-ruby gem TODO TODO T#
#                 ^^^^^^^ reference scip-ruby gem TODO TODO T#Boolean.
 end
