 # typed: true
 
#⌄ enclosing_range_start [..] M#
 module M
#       ^ definition [..] M#
   sig { returns(T::Boolean) }
#                   ^^^^^^^ reference [..] T#Boolean.
#  ⌄ enclosing_range_start [..] M#b().
   def b
#      ^ definition [..] M#b().
     true
   end
#    ⌃ enclosing_range_end [..] M#b().
 
#  ⌄ enclosing_range_start [..] `<Class:M>`#b().
   module_function :b
#                  ^^ definition [..] `<Class:M>`#b().
#                   ⌃ enclosing_range_end [..] `<Class:M>`#b().
 end
#  ⌃ enclosing_range_end [..] M#
