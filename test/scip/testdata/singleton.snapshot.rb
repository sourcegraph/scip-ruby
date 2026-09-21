 # typed: true
 
#⌄ enclosing_range_start [..] A#
 class A
#      ^ definition [..] A#
   include Singleton
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^^^ reference [..] Singleton#
#          ^^^^^^^^^ reference [..] Singleton#
 end
#  ⌃ enclosing_range_end [..] A#
 
 # Singleton supports inheritance, turning the sub-class into a singleton as well.
#⌄ enclosing_range_start [..] B#
 class B < A; end
#      ^ definition [..] B#
#          ^ reference [..] A#
#               ⌃ enclosing_range_end [..] B#
 
#⌄ enclosing_range_start [..] C#
 class C
#      ^ definition [..] C#
   include Singleton
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^^^ reference [..] Singleton#
#          ^^^^^^^^^ reference [..] Singleton#
   extend T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   final!
 end
#  ⌃ enclosing_range_end [..] C#
 
#⌄ enclosing_range_start [..] Object#f().
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
#  ⌃ enclosing_range_end [..] Object#f().
