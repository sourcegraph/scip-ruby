 # typed: true
 
 module M
#       ^ definition [..] M#
   def f; puts 'M.f'; end
#      ^ definition [..] M#f().
 end
 
 class C1
#      ^^ definition [..] C1#
   include M
#  ^^^^^^^ reference [..] Module#include().
#          ^ reference [..] M#
   def f; puts 'C1.f'; end
#      ^ definition [..] C1#f().
#         ^^^^ reference [..] Kernel#puts().
 end
 
 # f refers to C1.f
 class C2 < C1
#      ^^ definition [..] C2#
#           ^^ definition [..] C1#
 end
 
 # f refers to C1.f
 class C3 < C1
#      ^^ definition [..] C3#
#           ^^ definition [..] C1#
   include M
#  ^^^^^^^ reference [..] Module#include().
#          ^ reference [..] M#
 end
 
 class D1
#      ^^ definition [..] D1#
   def f; puts 'D1.f'; end
#      ^ definition [..] D1#f().
#         ^^^^ reference [..] Kernel#puts().
 end
 
 class D2
#      ^^ definition [..] D2#
   include M
#  ^^^^^^^ reference [..] Module#include().
#          ^ reference [..] M#
 end
 
 C1.new.f # C1.f
#^^ reference [..] C1#
#   ^^^ reference [..] Class#new().
#       ^ reference [..] C1#f().
 C2.new.f # C1.f
#^^ reference [..] C2#
#   ^^^ reference [..] Class#new().
#       ^ reference [..] C1#f().
 C3.new.f # C1.f
#^^ reference [..] C3#
#   ^^^ reference [..] Class#new().
#       ^ reference [..] C1#f().
 
 D1.new.f # D1.f
#^^ reference [..] D1#
#   ^^^ reference [..] Class#new().
#       ^ reference [..] D1#f().
 D2.new.f # M.f
#^^ reference [..] D2#
#   ^^^ reference [..] Class#new().
#       ^ reference [..] M#f().
 
 # Definition in directly included module and Self
 
 module T0
#       ^^ definition [..] T0#
   module M
#         ^ definition [..] T0#M#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T0#M#set_f_0().
#        ^^^^^^^ definition [..] T0#M#set_f_0().
#                 ^^ definition [..] T0#M#`@f`.
#                 ^^^^^^ reference [..] T0#M#`@f`.
   end
 
   class C
#        ^ definition [..] T0#C#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T0#M#
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T0#C#set_f_1().
#                 ^^ definition [..] T0#C#`@f`.
#                 relation reference=[..] T0#M#`@f`.
#                 ^^^^^^ reference [..] T0#C#`@f`.
     def get_f; @f; end
#        ^^^^^ definition [..] T0#C#get_f().
#               ^^ reference [..] T0#C#`@f`.
   end
 end
 
 # Definition in transitively included module and Self
 
 module T1
#       ^^ definition [..] T1#
   module M0
#         ^^ definition [..] T1#M0#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T1#M0#set_f_0().
#                 ^^ definition [..] T1#M0#`@f`.
#                 ^^^^^^ reference [..] T1#M0#`@f`.
   end
 
   module M1
#         ^^ definition [..] T1#M1#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T1#M0#
   end
 
   class C
#        ^ definition [..] T1#C#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T1#M1#
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T1#C#set_f_1().
#                 ^^ definition [..] T1#C#`@f`.
#                 relation reference=[..] T1#M0#`@f`.
#                 ^^^^^^ reference [..] T1#C#`@f`.
     def get_f; @f; end
#        ^^^^^ definition [..] T1#C#get_f().
#               ^^ reference [..] T1#C#`@f`.
   end
 end
 
 # Definition in directly included module only
 
 module T2
#       ^^ definition [..] T2#
   module M
#         ^ definition [..] T2#M#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T2#M#set_f_0().
#                 ^^ definition [..] T2#M#`@f`.
#                 ^^^^^^ reference [..] T2#M#`@f`.
   end
 
   class C
#        ^ definition [..] T2#C#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T2#M#
     def get_f; @f; end
#        ^^^^^ definition [..] T2#C#get_f().
#               ^^ reference [..] T2#C#`@f`.
   end
 end
 
 # Definition in transitively included module only
 
 module T3
#       ^^ definition [..] T3#
   module M0
#         ^^ definition [..] T3#M0#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T3#M0#set_f_0().
#        ^^^^^^^ definition [..] T3#M0#set_f_0().
#                 ^^ definition [..] T3#M0#`@f`.
#                 ^^^^^^ reference [..] T3#M0#`@f`.
   end
 
   module M1
#         ^^ definition [..] T3#M1#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T3#M0#
   end
 
   class C
#        ^ definition [..] T3#C#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T3#M1#
     def get_f; @f; end
#        ^^^^^ definition [..] T3#C#get_f().
#               ^^ reference [..] T3#C#`@f`.
   end
 end
 
 # Definition in directly included module & superclass & Self
 
 module T0
#       ^^ definition [..] T0#
   module M
#         ^ definition [..] T0#M#
     def set_f_0; @f = 0; end
#                 ^^ definition [..] T0#M#`@f`.
#                 ^^^^^^ reference [..] T0#M#`@f`.
   end
 
   class C0
#        ^^ definition [..] T0#C0#
     def set_f_2; @f = 2; end
#        ^^^^^^^ definition [..] T0#C0#set_f_2().
#                 ^^ definition [..] T0#C0#`@f`.
#                 ^^^^^^ reference [..] T0#C0#`@f`.
   end
 
   class C1 < C0
#        ^^ definition [..] T0#C1#
#             ^^ definition [..] T0#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T0#M#
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T0#C1#set_f_1().
#                 ^^ definition [..] T0#C1#`@f`.
#                 relation definition=[..] T0#C0#`@f`. reference=[..] T0#M#`@f`.
#                 ^^^^^^ reference [..] T0#C1#`@f`.
#                 relation definition=[..] T0#C0#`@f`. reference=[..] T0#M#`@f`.
     def get_f; @f; end
#        ^^^^^ definition [..] T0#C1#get_f().
#               ^^ reference [..] T0#C1#`@f`.
#               relation definition=[..] T0#C0#`@f`. reference=[..] T0#M#`@f`.
   end
 end
 
 # Definition in transitively included module & superclass & Self
 
 module T3
#       ^^ definition [..] T3#
   module M0
#         ^^ definition [..] T3#M0#
     def set_f_0; @f = 0; end
#                 ^^ definition [..] T3#M0#`@f`.
#                 ^^^^^^ reference [..] T3#M0#`@f`.
   end
 
   module M1
#         ^^ definition [..] T3#M1#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T3#M0#
   end
 
   class C0
#        ^^ definition [..] T3#C0#
     def set_f_2; @f = 2; end
#        ^^^^^^^ definition [..] T3#C0#set_f_2().
#                 ^^ definition [..] T3#C0#`@f`.
#                 ^^^^^^ reference [..] T3#C0#`@f`.
   end
 
   class C1 < C0
#        ^^ definition [..] T3#C1#
#             ^^ definition [..] T3#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] M#
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T3#C1#set_f_1().
#                 ^^ definition [..] T3#C1#`@f`.
#                 relation definition=[..] T3#C0#`@f`.
#                 ^^^^^^ reference [..] T3#C1#`@f`.
#                 relation definition=[..] T3#C0#`@f`.
     def get_f; @f; end
#        ^^^^^ definition [..] T3#C1#get_f().
#               ^^ reference [..] T3#C1#`@f`.
#               relation definition=[..] T3#C0#`@f`.
   end
 end
 
 # Definition in directly included module & superclass only
 
 module T4
#       ^^ definition [..] T4#
   module M
#         ^ definition [..] T4#M#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T4#M#set_f_0().
#                 ^^ definition [..] T4#M#`@f`.
#                 ^^^^^^ reference [..] T4#M#`@f`.
   end
 
   class C0
#        ^^ definition [..] T4#C0#
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T4#C0#set_f_1().
#                 ^^ definition [..] T4#C0#`@f`.
#                 ^^^^^^ reference [..] T4#C0#`@f`.
   end
 
   class C1 < C0
#        ^^ definition [..] T4#C1#
#             ^^ definition [..] T4#C0#
     def get_f; @f; end
#        ^^^^^ definition [..] T4#C1#get_f().
#               ^^ reference [..] T4#C1#`@f`.
#               relation definition=[..] T4#C0#`@f`.
   end
 end
 
 # Definition in transitively included module & superclass only
 
 module T5
#       ^^ definition [..] T5#
   module M0
#         ^^ definition [..] T5#M0#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T5#M0#set_f_0().
#                 ^^ definition [..] T5#M0#`@f`.
#                 ^^^^^^ reference [..] T5#M0#`@f`.
   end
 
   module M1
#         ^^ definition [..] T5#M1#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T5#M0#
   end
 
   class C0
#        ^^ definition [..] T5#C0#
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T5#C0#set_f_1().
#                 ^^ definition [..] T5#C0#`@f`.
#                 ^^^^^^ reference [..] T5#C0#`@f`.
   end
 
   class C1 < C0
#        ^^ definition [..] T5#C1#
#             ^^ definition [..] T5#C0#
     def get_f; @f; end
#        ^^^^^ definition [..] T5#C1#get_f().
#               ^^ reference [..] T5#C1#`@f`.
#               relation definition=[..] T5#C0#`@f`.
   end
 end
 
 # Definition in module included via superclass & superclass & Self
 
 module T6
#       ^^ definition [..] T6#
   module M
#         ^ definition [..] T6#M#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T6#M#set_f_0().
#                 ^^ definition [..] T6#M#`@f`.
#                 ^^^^^^ reference [..] T6#M#`@f`.
   end
 
   class C0
#        ^^ definition [..] T6#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T6#M#
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T6#C0#set_f_1().
#                 ^^ definition [..] T6#C0#`@f`.
#                 relation reference=[..] T6#M#`@f`.
#                 ^^^^^^ reference [..] T6#C0#`@f`.
   end
 
   class C1 < C0
#        ^^ definition [..] T6#C1#
#             ^^ definition [..] T6#C0#
     def set_f_2; @f = 2; end
#        ^^^^^^^ definition [..] T6#C1#set_f_2().
#                 ^^ definition [..] T6#C1#`@f`.
#                 relation definition=[..] T6#C0#`@f`.
#                 ^^^^^^ reference [..] T6#C1#`@f`.
#                 relation definition=[..] T6#C0#`@f`.
     def get_f; @f; end
#        ^^^^^ definition [..] T6#C1#get_f().
#               ^^ reference [..] T6#C1#`@f`.
#               relation definition=[..] T6#C0#`@f`.
   end
 end
 
 # Definition in module included via superclass & superclass only
 
 module T7
#       ^^ definition [..] T7#
   module M
#         ^ definition [..] T7#M#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T7#M#set_f_0().
#                 ^^ definition [..] T7#M#`@f`.
#                 ^^^^^^ reference [..] T7#M#`@f`.
   end
 
   class C0
#        ^^ definition [..] T7#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T7#M#
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T7#C0#set_f_1().
#                 ^^ definition [..] T7#C0#`@f`.
#                 relation reference=[..] T7#M#`@f`.
#                 ^^^^^^ reference [..] T7#C0#`@f`.
   end
 
   class C1 < C0
#        ^^ definition [..] T7#C1#
#             ^^ definition [..] T7#C0#
     def get_f; @f; end
#        ^^^^^ definition [..] T7#C1#get_f().
#               ^^ reference [..] T7#C1#`@f`.
#               relation definition=[..] T7#C0#`@f`.
   end
 end
 
 # Definition in module included via superclass & Self
 
 module T8
#       ^^ definition [..] T8#
   module M
#         ^ definition [..] T8#M#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T8#M#set_f_0().
#                 ^^ definition [..] T8#M#`@f`.
#                 ^^^^^^ reference [..] T8#M#`@f`.
   end
 
   class C0
#        ^^ definition [..] T8#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T8#M#
   end
 
   class C1 < C0
#        ^^ definition [..] T8#C1#
#             ^^ definition [..] T8#C0#
     def set_f_2; @f = 2; end
#        ^^^^^^^ definition [..] T8#C1#set_f_2().
#                 ^^ definition [..] T8#C1#`@f`.
#                 ^^^^^^ reference [..] T8#C1#`@f`.
     def get_f; @f; end
#        ^^^^^ definition [..] T8#C1#get_f().
#               ^^ reference [..] T8#C1#`@f`.
   end
 end
 
 # Definition in module included via superclass only
 
 module T9
#       ^^ definition [..] T9#
   module M
#         ^ definition [..] T9#M#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T9#M#set_f_0().
#                 ^^ definition [..] T9#M#`@f`.
#                 ^^^^^^ reference [..] T9#M#`@f`.
   end
 
   class C0
#        ^^ definition [..] T9#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T9#M#
   end
 
   class C1 < C0
#        ^^ definition [..] T9#C1#
#             ^^ definition [..] T9#C0#
     def get_f; @f; end
#        ^^^^^ definition [..] T9#C1#get_f().
#               ^^ reference [..] T9#C1#`@f`.
   end
 end
 
 # Definition in multiple transitively included modules & common child & Self
 
 module T10
#       ^^^ definition [..] T10#
   module M0
#         ^^ definition [..] T10#M0#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T10#M0#set_f_0().
#                 ^^ definition [..] T10#M0#`@f`.
#                 ^^^^^^ reference [..] T10#M0#`@f`.
   end
 
   module M1
#         ^^ definition [..] T10#M1#
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T10#M1#set_f_1().
#                 ^^ definition [..] T10#M1#`@f`.
#                 ^^^^^^ reference [..] T10#M1#`@f`.
   end
 
   module M2
#         ^^ definition [..] T10#M2#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T10#M0#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T10#M1#
     def set_f_2; @f = 2; end
#        ^^^^^^^ definition [..] T10#M2#set_f_2().
#                 ^^ definition [..] T10#M2#`@f`.
#                 relation reference=[..] T10#M0#`@f`. reference=[..] T10#M1#`@f`.
#                 ^^^^^^ reference [..] T10#M2#`@f`.
   end
 
   class C
#        ^ definition [..] T10#C#
     include M2
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T10#M2#
     def set_f_3; @f = 3; end
#        ^^^^^^^ definition [..] T10#C#set_f_3().
#                 ^^ definition [..] T10#C#`@f`.
#                 relation reference=[..] T10#M0#`@f`. reference=[..] T10#M1#`@f`. reference=[..] T10#M2#`@f`.
#                 ^^^^^^ reference [..] T10#C#`@f`.
     def get_f; @f; end
#        ^^^^^ definition [..] T10#C#get_f().
#               ^^ reference [..] T10#C#`@f`.
   end
 end
 
 # Definition in multiple transitively included modules & common child only
 
 module T11
#       ^^^ definition [..] T11#
   module M0
#         ^^ definition [..] T11#M0#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T11#M0#set_f_0().
#                 ^^ definition [..] T11#M0#`@f`.
#                 ^^^^^^ reference [..] T11#M0#`@f`.
   end
 
   module M1
#         ^^ definition [..] T11#M1#
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T11#M1#set_f_1().
#                 ^^ definition [..] T11#M1#`@f`.
#                 ^^^^^^ reference [..] T11#M1#`@f`.
   end
 
   module M2
#         ^^ definition [..] T11#M2#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T11#M0#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T11#M1#
     def set_f_2; @f = 2; end
#        ^^^^^^^ definition [..] T11#M2#set_f_2().
#                 ^^ definition [..] T11#M2#`@f`.
#                 relation reference=[..] T11#M0#`@f`. reference=[..] T11#M1#`@f`.
#                 ^^^^^^ reference [..] T11#M2#`@f`.
   end
 
   class C
#        ^ definition [..] T11#C#
     include M2
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T11#M2#
     def get_f; @f; end
#        ^^^^^ definition [..] T11#C#get_f().
#               ^^ reference [..] T11#C#`@f`.
   end
 end
 
 # Definition in multiple transitively included modules & Self
 
 module T12
#       ^^^ definition [..] T12#
   module M0
#         ^^ definition [..] T12#M0#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T12#M0#set_f_0().
#                 ^^ definition [..] T12#M0#`@f`.
#                 ^^^^^^ reference [..] T12#M0#`@f`.
   end
 
   module M1
#         ^^ definition [..] T12#M1#
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T12#M1#set_f_1().
#                 ^^ definition [..] T12#M1#`@f`.
#                 ^^^^^^ reference [..] T12#M1#`@f`.
   end
 
   module M2
#         ^^ definition [..] T12#M2#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T12#M0#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T12#M1#
   end
 
   class C
#        ^ definition [..] T12#C#
     include M2
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T12#M2#
     def set_f_3; @f = 3; end
#        ^^^^^^^ definition [..] T12#C#set_f_3().
#                 ^^ definition [..] T12#C#`@f`.
#                 relation reference=[..] T12#M0#`@f`. reference=[..] T12#M1#`@f`.
#                 ^^^^^^ reference [..] T12#C#`@f`.
     def get_f; @f; end
#        ^^^^^ definition [..] T12#C#get_f().
#               ^^ reference [..] T12#C#`@f`.
   end
 end
 
 # Definition in multiple transitively included modules only
 
 module T13
#       ^^^ definition [..] T13#
   module M0
#         ^^ definition [..] T13#M0#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T13#M0#set_f_0().
#                 ^^ definition [..] T13#M0#`@f`.
#                 ^^^^^^ reference [..] T13#M0#`@f`.
   end
 
   module M1
#         ^^ definition [..] T13#M1#
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T13#M1#set_f_1().
#                 ^^ definition [..] T13#M1#`@f`.
#                 ^^^^^^ reference [..] T13#M1#`@f`.
   end
 
   module M2
#         ^^ definition [..] T13#M2#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T13#M0#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T13#M1#
   end
 
   class C
#        ^ definition [..] T13#C#
     include M2
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T13#M2#
     def get_f; @f; end
#        ^^^^^ definition [..] T13#C#get_f().
#               ^^ reference [..] T13#C#`@f`.
   end
 end
 
 # Definition in multiple directly included modules & Self
 
 module T14
#       ^^^ definition [..] T14#
   module M0
#         ^^ definition [..] T14#M0#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T14#M0#set_f_0().
#                 ^^ definition [..] T14#M0#`@f`.
#                 ^^^^^^ reference [..] T14#M0#`@f`.
   end
 
   module M1
#         ^^ definition [..] T14#M1#
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T14#M1#set_f_1().
#                 ^^ definition [..] T14#M1#`@f`.
#                 ^^^^^^ reference [..] T14#M1#`@f`.
   end
 
   class C
#        ^ definition [..] T14#C#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T14#M0#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T14#M1#
     def set_f_2; @f = 2; end
#        ^^^^^^^ definition [..] T14#C#set_f_2().
#                 ^^ definition [..] T14#C#`@f`.
#                 relation reference=[..] T14#M0#`@f`. reference=[..] T14#M1#`@f`.
#                 ^^^^^^ reference [..] T14#C#`@f`.
     def get_f; @f; end
#        ^^^^^ definition [..] T14#C#get_f().
#               ^^ reference [..] T14#C#`@f`.
   end
 end
 
 # Definition in multiple directly included modules only
 
 module T15
#       ^^^ definition [..] T15#
   module M0
#         ^^ definition [..] T15#M0#
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T15#M0#set_f_0().
#                 ^^ definition [..] T15#M0#`@f`.
#                 ^^^^^^ reference [..] T15#M0#`@f`.
   end
 
   module M1
#         ^^ definition [..] T15#M1#
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T15#M1#set_f_1().
#                 ^^ definition [..] T15#M1#`@f`.
#                 ^^^^^^ reference [..] T15#M1#`@f`.
   end
 
   class C
#        ^ definition [..] T15#C#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T15#M0#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T15#M1#
     def get_f; @f; end
#        ^^^^^ definition [..] T15#C#get_f().
#               ^^ reference [..] T15#C#`@f`.
   end
 end
 
 # OKAY! Now for the more "weird" situations
 # Before this, all the tests had a definition come "before" use.
 # Let's see what happens if there is a use before any definition.
 
 # Reference in directly included module with def in Self
 
 module W0
#       ^^ definition [..] W0#
   module M
#         ^ definition [..] W0#M#
     def get_f; @f; end
#        ^^^^^ definition [..] W0#M#get_f().
#               ^^ reference [..] W0#M#`@f`.
   end
 
   class C
#        ^ definition [..] W0#C#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] W0#M#
     def set_f; @f = 0; end
#        ^^^^^ definition [..] W0#C#set_f().
#               ^^ definition [..] W0#C#`@f`.
#               relation reference=[..] W0#M#`@f`.
#               ^^^^^^ reference [..] W0#C#`@f`.
   end
 end
 
 # Reference in transitively included module with def in Self
 
 module W1
#       ^^ definition [..] W1#
   module M0
#         ^^ definition [..] W1#M0#
     def get_f; @f; end
#        ^^^^^ definition [..] W1#M0#get_f().
#               ^^ reference [..] W1#M0#`@f`.
   end
   
   module M1
#         ^^ definition [..] W1#M1#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] W1#M0#
   end
 
   class C
#        ^ definition [..] W1#C#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] W1#M1#
     def set_f; @f = 0; end
#        ^^^^^ definition [..] W1#C#set_f().
#               ^^ definition [..] W1#C#`@f`.
#               relation reference=[..] W1#M0#`@f`.
#               ^^^^^^ reference [..] W1#C#`@f`.
   end
 end
 
 # Reference in superclass with def in directly included module
 
 module W2
#       ^^ definition [..] W2#
   module M
#         ^ definition [..] W2#M#
     def set_f; @f = 0; end
#        ^^^^^ definition [..] W2#M#set_f().
#               ^^ definition [..] W2#M#`@f`.
#               ^^^^^^ reference [..] W2#M#`@f`.
   end
 
   class C0
#        ^^ definition [..] W2#C0#
     def get_f; @f; end
#        ^^^^^ definition [..] W2#C0#get_f().
#               ^^ reference [..] W2#C0#`@f`.
   end
 
   class C1 < C0
#        ^^ definition [..] W2#C1#
#             ^^ definition [..] W2#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] W2#M#
     def get_fp1; @f + 1; end
#        ^^^^^^^ definition [..] W2#C1#get_fp1().
#        ^^^^^^^ definition [..] W2#C1#get_fp1().
#                 ^^ reference [..] W2#C1#`@f`.
#                 relation definition=[..] W2#C0#`@f`. reference=[..] W2#M#`@f`.
   end
 end
 
 # Reference in directly included module with def in superclass
 
 module W2
#       ^^ definition [..] W2#
   module M
#         ^ definition [..] W2#M#
     def get_f; @f; end
#        ^^^^^ definition [..] W2#M#get_f().
#               ^^ reference [..] W2#M#`@f`.
   end
 
   class C0
#        ^^ definition [..] W2#C0#
     def set_f; @f = 0; end
#        ^^^^^ definition [..] W2#C0#set_f().
#               ^^ definition [..] W2#C0#`@f`.
#               ^^^^^^ reference [..] W2#C0#`@f`.
   end
 
   class C1 < C0
#        ^^ definition [..] W2#C1#
#             ^^ definition [..] W2#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] W2#M#
     def get_fp1; @f + 1; end
#                 ^^ reference [..] W2#C1#`@f`.
#                 relation definition=[..] W2#C0#`@f`. reference=[..] W2#M#`@f`.
   end
 end
 
 # Reference in transitively included module with def in in-between module
 
 module W3
#       ^^ definition [..] W3#
   module M0
#         ^^ definition [..] W3#M0#
     def get_f; @f; end
#        ^^^^^ definition [..] W3#M0#get_f().
#               ^^ reference [..] W3#M0#`@f`.
   end
 
   module M1
#         ^^ definition [..] W3#M1#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] W3#M0#
     def set_f; @f = 0; end
#        ^^^^^ definition [..] W3#M1#set_f().
#               ^^ definition [..] W3#M1#`@f`.
#               relation reference=[..] W3#M0#`@f`.
#               ^^^^^^ reference [..] W3#M1#`@f`.
   end
 
   class C
#        ^ definition [..] W3#C#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] W3#M1#
     def get_fp1; @f + 1; end
#        ^^^^^^^ definition [..] W3#C#get_fp1().
#                 ^^ reference [..] W3#C#`@f`.
   end
 end
 
 # Reference in one directly included module with def in other directly included module
 
 module W4
#       ^^ definition [..] W4#
   module M0
#         ^^ definition [..] W4#M0#
     def get_f; @f; end
#        ^^^^^ definition [..] W4#M0#get_f().
#               ^^ reference [..] W4#M0#`@f`.
   end
 
   module M1
#         ^^ definition [..] W4#M1#
     def set_f; @f + 1; end
#        ^^^^^ definition [..] W4#M1#set_f().
#               ^^ reference [..] W4#M1#`@f`.
   end
 
   class C
#        ^ definition [..] W4#C#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] W4#M0#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] W4#M1#
     def get_fp1; @f + 1; end
#        ^^^^^^^ definition [..] W4#C#get_fp1().
#                 ^^ reference [..] W4#C#`@f`.
   end
 end
 
