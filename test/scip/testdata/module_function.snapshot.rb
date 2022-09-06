 # typed: true
 
 module M
#       ^ definition [..] M#
   sig { returns(T::Boolean) }
#                   ^^^^^^^ reference [..] T#Boolean.
   def b
#      ^ definition [..] M#b().
     true
   end
 
   module_function :b
#                  ^^ definition [..] `<Class:M>`#b().
 end
