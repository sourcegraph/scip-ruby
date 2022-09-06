 # typed: true
 
 class A
#      ^ definition [..] A#
   include Singleton
#  ^^^^^^^^^^^^^^^^^ definition [..] `<Class:A>`#instance().
#          ^^^^^^^^^ reference [..] Singleton#
 end
 
 # Singleton supports inheritance, turning the sub-class into a singleton as well.
 class B < A; end
#      ^ definition [..] B#
#          ^ definition [..] A#
 
 class C
#      ^ definition [..] C#
   include Singleton
#  ^^^^^^^^^^^^^^^^^ definition [..] `<Class:C>`#instance().
#          ^^^^^^^^^ reference [..] Singleton#
   extend T::Helpers
   final!
 end
 
 def f
#    ^ definition [..] Object#f().
   return [A.instance, B.instance, C.instance]
#          ^ reference [..] A#
#            ^^^^^^^^ reference [..] `<Class:A>`#instance().
#                      ^ reference [..] B#
#                                  ^ reference [..] C#
#                                    ^^^^^^^^ reference [..] `<Class:C>`#instance().
 end
