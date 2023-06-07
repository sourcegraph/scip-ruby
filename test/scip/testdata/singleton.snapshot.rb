 # typed: true
 
 class A
#      ^ definition [..] A#
   include Singleton
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^^^ reference [..] Singleton#
 end
 
 # Singleton supports inheritance, turning the sub-class into a singleton as well.
 class B < A; end
#      ^ definition [..] B#
#          ^ definition [..] A#
 
 class C
#      ^ definition [..] C#
   include Singleton
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^^^ reference [..] Singleton#
   extend T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   final!
 end
 
 def f
#    ^ definition [..] Object#f().
   return [A.instance, B.instance, C.instance]
#          ^ reference [..] A#
#            ^^^^^^^^ reference [..] Singleton#SingletonClassMethods#instance().
#                      ^ reference [..] B#
#                        ^^^^^^^^ reference [..] Singleton#SingletonClassMethods#instance().
#                                  ^ reference [..] C#
#                                    ^^^^^^^^ reference [..] Singleton#SingletonClassMethods#instance().
 end
