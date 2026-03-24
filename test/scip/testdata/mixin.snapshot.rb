 # typed: true
 
#⌄ enclosing_range_start [..] M#
 module M
#       ^ definition [..] M#
#  ⌄ enclosing_range_start [..] M#f().
   def f; puts 'M.f'; end
#      ^ definition [..] M#f().
#                       ⌃ enclosing_range_end [..] M#f().
 end
#  ⌃ enclosing_range_end [..] M#
 
#⌄ enclosing_range_start [..] C1#
 class C1
#      ^^ definition [..] C1#
   include M
#  ^^^^^^^ reference [..] Module#include().
#          ^ reference [..] M#
#          ^ reference [..] M#
#  ⌄ enclosing_range_start [..] C1#f().
   def f; puts 'C1.f'; end
#      ^ definition [..] C1#f().
#         ^^^^ reference [..] Kernel#puts().
#                        ⌃ enclosing_range_end [..] C1#f().
 end
#  ⌃ enclosing_range_end [..] C1#
 
 # f refers to C1.f
#⌄ enclosing_range_start [..] C2#
 class C2 < C1
#      ^^ definition [..] C2#
#           ^^ reference [..] C1#
 end
#  ⌃ enclosing_range_end [..] C2#
 
 # f refers to C1.f
#⌄ enclosing_range_start [..] C3#
 class C3 < C1
#      ^^ definition [..] C3#
#           ^^ reference [..] C1#
   include M
#  ^^^^^^^ reference [..] Module#include().
#          ^ reference [..] M#
#          ^ reference [..] M#
 end
#  ⌃ enclosing_range_end [..] C3#
 
#⌄ enclosing_range_start [..] D1#
 class D1
#      ^^ definition [..] D1#
#  ⌄ enclosing_range_start [..] D1#f().
   def f; puts 'D1.f'; end
#      ^ definition [..] D1#f().
#         ^^^^ reference [..] Kernel#puts().
#                        ⌃ enclosing_range_end [..] D1#f().
 end
#  ⌃ enclosing_range_end [..] D1#
 
#⌄ enclosing_range_start [..] D2#
 class D2
#      ^^ definition [..] D2#
   include M
#  ^^^^^^^ reference [..] Module#include().
#          ^ reference [..] M#
#          ^ reference [..] M#
 end
#  ⌃ enclosing_range_end [..] D2#
 
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
 
#⌄ enclosing_range_start [..] T0#
 module T0
#       ^^ definition [..] T0#
#  ⌄ enclosing_range_start [..] T0#M#
   module M
#         ^ definition [..] T0#M#
#    ⌄ enclosing_range_start [..] T0#M#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T0#M#set_f_0().
#                 ^^ definition [..] T0#M#`@f`.
#                 ^^^^^^ reference [..] T0#M#`@f`.
#                           ⌃ enclosing_range_end [..] T0#M#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T0#M#
 
#  ⌄ enclosing_range_start [..] T0#C#
   class C
#        ^ definition [..] T0#C#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T0#M#
#            ^ reference [..] T0#M#
#    ⌄ enclosing_range_start [..] T0#C#set_f_1().
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T0#C#set_f_1().
#                 ^^ definition [..] T0#C#`@f`.
#                 relation reference=[..] T0#M#`@f`.
#                 ^^^^^^ reference [..] T0#C#`@f`.
#                           ⌃ enclosing_range_end [..] T0#C#set_f_1().
#    ⌄ enclosing_range_start [..] T0#C#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T0#C#get_f().
#               ^^ reference [..] T0#C#`@f`.
#                     ⌃ enclosing_range_end [..] T0#C#get_f().
   end
#    ⌃ enclosing_range_end [..] T0#C#
 end
#  ⌃ enclosing_range_end [..] T0#
 
 # Definition in transitively included module and Self
 
#⌄ enclosing_range_start [..] T1#
 module T1
#       ^^ definition [..] T1#
#  ⌄ enclosing_range_start [..] T1#M0#
   module M0
#         ^^ definition [..] T1#M0#
#    ⌄ enclosing_range_start [..] T1#M0#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T1#M0#set_f_0().
#                 ^^ definition [..] T1#M0#`@f`.
#                 ^^^^^^ reference [..] T1#M0#`@f`.
#                           ⌃ enclosing_range_end [..] T1#M0#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T1#M0#
 
#  ⌄ enclosing_range_start [..] T1#M1#
   module M1
#         ^^ definition [..] T1#M1#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T1#M0#
#            ^^ reference [..] T1#M0#
   end
#    ⌃ enclosing_range_end [..] T1#M1#
 
#  ⌄ enclosing_range_start [..] T1#C#
   class C
#        ^ definition [..] T1#C#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T1#M1#
#            ^^ reference [..] T1#M1#
#    ⌄ enclosing_range_start [..] T1#C#set_f_1().
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T1#C#set_f_1().
#                 ^^ definition [..] T1#C#`@f`.
#                 relation reference=[..] T1#M0#`@f`.
#                 ^^^^^^ reference [..] T1#C#`@f`.
#                           ⌃ enclosing_range_end [..] T1#C#set_f_1().
#    ⌄ enclosing_range_start [..] T1#C#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T1#C#get_f().
#               ^^ reference [..] T1#C#`@f`.
#                     ⌃ enclosing_range_end [..] T1#C#get_f().
   end
#    ⌃ enclosing_range_end [..] T1#C#
 end
#  ⌃ enclosing_range_end [..] T1#
 
 # Definition in directly included module only
 
#⌄ enclosing_range_start [..] T2#
 module T2
#       ^^ definition [..] T2#
#  ⌄ enclosing_range_start [..] T2#M#
   module M
#         ^ definition [..] T2#M#
#    ⌄ enclosing_range_start [..] T2#M#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T2#M#set_f_0().
#                 ^^ definition [..] T2#M#`@f`.
#                 ^^^^^^ reference [..] T2#M#`@f`.
#                           ⌃ enclosing_range_end [..] T2#M#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T2#M#
 
#  ⌄ enclosing_range_start [..] T2#C#
   class C
#        ^ definition [..] T2#C#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T2#M#
#            ^ reference [..] T2#M#
#    ⌄ enclosing_range_start [..] T2#C#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T2#C#get_f().
#               ^^ reference [..] T2#C#`@f`.
#                     ⌃ enclosing_range_end [..] T2#C#get_f().
   end
#    ⌃ enclosing_range_end [..] T2#C#
 end
#  ⌃ enclosing_range_end [..] T2#
 
 # Definition in transitively included module only
 
#⌄ enclosing_range_start [..] T3#
 module T3
#       ^^ definition [..] T3#
#  ⌄ enclosing_range_start [..] T3#M0#
   module M0
#         ^^ definition [..] T3#M0#
#    ⌄ enclosing_range_start [..] T3#M0#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T3#M0#set_f_0().
#                 ^^ definition [..] T3#M0#`@f`.
#                 ^^^^^^ reference [..] T3#M0#`@f`.
#                           ⌃ enclosing_range_end [..] T3#M0#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T3#M0#
 
#  ⌄ enclosing_range_start [..] T3#M1#
   module M1
#         ^^ definition [..] T3#M1#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T3#M0#
#            ^^ reference [..] T3#M0#
   end
#    ⌃ enclosing_range_end [..] T3#M1#
 
#  ⌄ enclosing_range_start [..] T3#C#
   class C
#        ^ definition [..] T3#C#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T3#M1#
#            ^^ reference [..] T3#M1#
#    ⌄ enclosing_range_start [..] T3#C#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T3#C#get_f().
#               ^^ reference [..] T3#C#`@f`.
#                     ⌃ enclosing_range_end [..] T3#C#get_f().
   end
#    ⌃ enclosing_range_end [..] T3#C#
 end
#  ⌃ enclosing_range_end [..] T3#
 
 # Definition in directly included module & superclass & Self
 
#⌄ enclosing_range_start [..] T4#
 module T4
#       ^^ definition [..] T4#
#  ⌄ enclosing_range_start [..] T4#M#
   module M
#         ^ definition [..] T4#M#
#    ⌄ enclosing_range_start [..] T4#M#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T4#M#set_f_0().
#                 ^^ definition [..] T4#M#`@f`.
#                 ^^^^^^ reference [..] T4#M#`@f`.
#                           ⌃ enclosing_range_end [..] T4#M#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T4#M#
 
#  ⌄ enclosing_range_start [..] T4#C0#
   class C0
#        ^^ definition [..] T4#C0#
#    ⌄ enclosing_range_start [..] T4#C0#set_f_2().
     def set_f_2; @f = 2; end
#        ^^^^^^^ definition [..] T4#C0#set_f_2().
#                 ^^ definition [..] T4#C0#`@f`.
#                 ^^^^^^ reference [..] T4#C0#`@f`.
#                           ⌃ enclosing_range_end [..] T4#C0#set_f_2().
   end
#    ⌃ enclosing_range_end [..] T4#C0#
 
#  ⌄ enclosing_range_start [..] T4#C1#
   class C1 < C0
#        ^^ definition [..] T4#C1#
#             ^^ reference [..] T4#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T4#M#
#            ^ reference [..] T4#M#
#    ⌄ enclosing_range_start [..] T4#C1#set_f_1().
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T4#C1#set_f_1().
#                 ^^ definition [..] T4#C1#`@f`.
#                 relation definition=[..] T4#C0#`@f`. reference=[..] T4#M#`@f`.
#                 ^^^^^^ reference [..] T4#C1#`@f`.
#                 relation definition=[..] T4#C0#`@f`. reference=[..] T4#M#`@f`.
#                           ⌃ enclosing_range_end [..] T4#C1#set_f_1().
#    ⌄ enclosing_range_start [..] T4#C1#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T4#C1#get_f().
#               ^^ reference [..] T4#C1#`@f`.
#               relation definition=[..] T4#C0#`@f`. reference=[..] T4#M#`@f`.
#                     ⌃ enclosing_range_end [..] T4#C1#get_f().
   end
#    ⌃ enclosing_range_end [..] T4#C1#
 end
#  ⌃ enclosing_range_end [..] T4#
 
 # Definition in transitively included module & superclass & Self
 
#⌄ enclosing_range_start [..] T5#
 module T5
#       ^^ definition [..] T5#
#  ⌄ enclosing_range_start [..] T5#M0#
   module M0
#         ^^ definition [..] T5#M0#
#    ⌄ enclosing_range_start [..] T5#M0#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T5#M0#set_f_0().
#                 ^^ definition [..] T5#M0#`@f`.
#                 ^^^^^^ reference [..] T5#M0#`@f`.
#                           ⌃ enclosing_range_end [..] T5#M0#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T5#M0#
 
#  ⌄ enclosing_range_start [..] T5#M1#
   module M1
#         ^^ definition [..] T5#M1#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T5#M0#
#            ^^ reference [..] T5#M0#
   end
#    ⌃ enclosing_range_end [..] T5#M1#
 
#  ⌄ enclosing_range_start [..] T5#C0#
   class C0
#        ^^ definition [..] T5#C0#
#    ⌄ enclosing_range_start [..] T5#C0#set_f_2().
     def set_f_2; @f = 2; end
#        ^^^^^^^ definition [..] T5#C0#set_f_2().
#                 ^^ definition [..] T5#C0#`@f`.
#                 ^^^^^^ reference [..] T5#C0#`@f`.
#                           ⌃ enclosing_range_end [..] T5#C0#set_f_2().
   end
#    ⌃ enclosing_range_end [..] T5#C0#
 
#  ⌄ enclosing_range_start [..] T5#C1#
   class C1 < C0
#        ^^ definition [..] T5#C1#
#             ^^ reference [..] T5#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] M#
#            ^ reference [..] M#
#    ⌄ enclosing_range_start [..] T5#C1#set_f_1().
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T5#C1#set_f_1().
#                 ^^ definition [..] T5#C1#`@f`.
#                 relation definition=[..] T5#C0#`@f`.
#                 ^^^^^^ reference [..] T5#C1#`@f`.
#                 relation definition=[..] T5#C0#`@f`.
#                           ⌃ enclosing_range_end [..] T5#C1#set_f_1().
#    ⌄ enclosing_range_start [..] T5#C1#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T5#C1#get_f().
#               ^^ reference [..] T5#C1#`@f`.
#               relation definition=[..] T5#C0#`@f`.
#                     ⌃ enclosing_range_end [..] T5#C1#get_f().
   end
#    ⌃ enclosing_range_end [..] T5#C1#
 end
#  ⌃ enclosing_range_end [..] T5#
 
 # Definition in directly included module & superclass only
 
#⌄ enclosing_range_start [..] T6#
 module T6
#       ^^ definition [..] T6#
#  ⌄ enclosing_range_start [..] T6#M#
   module M
#         ^ definition [..] T6#M#
#    ⌄ enclosing_range_start [..] T6#M#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T6#M#set_f_0().
#                 ^^ definition [..] T6#M#`@f`.
#                 ^^^^^^ reference [..] T6#M#`@f`.
#                           ⌃ enclosing_range_end [..] T6#M#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T6#M#
 
#  ⌄ enclosing_range_start [..] T6#C0#
   class C0
#        ^^ definition [..] T6#C0#
#    ⌄ enclosing_range_start [..] T6#C0#set_f_1().
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T6#C0#set_f_1().
#                 ^^ definition [..] T6#C0#`@f`.
#                 ^^^^^^ reference [..] T6#C0#`@f`.
#                           ⌃ enclosing_range_end [..] T6#C0#set_f_1().
   end
#    ⌃ enclosing_range_end [..] T6#C0#
 
#  ⌄ enclosing_range_start [..] T6#C1#
   class C1 < C0
#        ^^ definition [..] T6#C1#
#             ^^ reference [..] T6#C0#
#    ⌄ enclosing_range_start [..] T6#C1#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T6#C1#get_f().
#               ^^ reference [..] T6#C1#`@f`.
#               relation definition=[..] T6#C0#`@f`.
#                     ⌃ enclosing_range_end [..] T6#C1#get_f().
   end
#    ⌃ enclosing_range_end [..] T6#C1#
 end
#  ⌃ enclosing_range_end [..] T6#
 
 # Definition in transitively included module & superclass only
 
#⌄ enclosing_range_start [..] T7#
 module T7
#       ^^ definition [..] T7#
#  ⌄ enclosing_range_start [..] T7#M0#
   module M0
#         ^^ definition [..] T7#M0#
#    ⌄ enclosing_range_start [..] T7#M0#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T7#M0#set_f_0().
#                 ^^ definition [..] T7#M0#`@f`.
#                 ^^^^^^ reference [..] T7#M0#`@f`.
#                           ⌃ enclosing_range_end [..] T7#M0#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T7#M0#
 
#  ⌄ enclosing_range_start [..] T7#M1#
   module M1
#         ^^ definition [..] T7#M1#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T7#M0#
#            ^^ reference [..] T7#M0#
   end
#    ⌃ enclosing_range_end [..] T7#M1#
 
#  ⌄ enclosing_range_start [..] T7#C0#
   class C0
#        ^^ definition [..] T7#C0#
#    ⌄ enclosing_range_start [..] T7#C0#set_f_1().
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T7#C0#set_f_1().
#                 ^^ definition [..] T7#C0#`@f`.
#                 ^^^^^^ reference [..] T7#C0#`@f`.
#                           ⌃ enclosing_range_end [..] T7#C0#set_f_1().
   end
#    ⌃ enclosing_range_end [..] T7#C0#
 
#  ⌄ enclosing_range_start [..] T7#C1#
   class C1 < C0
#        ^^ definition [..] T7#C1#
#             ^^ reference [..] T7#C0#
#    ⌄ enclosing_range_start [..] T7#C1#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T7#C1#get_f().
#               ^^ reference [..] T7#C1#`@f`.
#               relation definition=[..] T7#C0#`@f`.
#                     ⌃ enclosing_range_end [..] T7#C1#get_f().
   end
#    ⌃ enclosing_range_end [..] T7#C1#
 end
#  ⌃ enclosing_range_end [..] T7#
 
 # Definition in module included via superclass & superclass & Self
 
#⌄ enclosing_range_start [..] T8#
 module T8
#       ^^ definition [..] T8#
#  ⌄ enclosing_range_start [..] T8#M#
   module M
#         ^ definition [..] T8#M#
#    ⌄ enclosing_range_start [..] T8#M#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T8#M#set_f_0().
#                 ^^ definition [..] T8#M#`@f`.
#                 ^^^^^^ reference [..] T8#M#`@f`.
#                           ⌃ enclosing_range_end [..] T8#M#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T8#M#
 
#  ⌄ enclosing_range_start [..] T8#C0#
   class C0
#        ^^ definition [..] T8#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T8#M#
#            ^ reference [..] T8#M#
#    ⌄ enclosing_range_start [..] T8#C0#set_f_1().
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T8#C0#set_f_1().
#                 ^^ definition [..] T8#C0#`@f`.
#                 relation reference=[..] T8#M#`@f`.
#                 ^^^^^^ reference [..] T8#C0#`@f`.
#                           ⌃ enclosing_range_end [..] T8#C0#set_f_1().
   end
#    ⌃ enclosing_range_end [..] T8#C0#
 
#  ⌄ enclosing_range_start [..] T8#C1#
   class C1 < C0
#        ^^ definition [..] T8#C1#
#             ^^ reference [..] T8#C0#
#    ⌄ enclosing_range_start [..] T8#C1#set_f_2().
     def set_f_2; @f = 2; end
#        ^^^^^^^ definition [..] T8#C1#set_f_2().
#                 ^^ definition [..] T8#C1#`@f`.
#                 relation definition=[..] T8#C0#`@f`.
#                 ^^^^^^ reference [..] T8#C1#`@f`.
#                 relation definition=[..] T8#C0#`@f`.
#                           ⌃ enclosing_range_end [..] T8#C1#set_f_2().
#    ⌄ enclosing_range_start [..] T8#C1#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T8#C1#get_f().
#               ^^ reference [..] T8#C1#`@f`.
#               relation definition=[..] T8#C0#`@f`.
#                     ⌃ enclosing_range_end [..] T8#C1#get_f().
   end
#    ⌃ enclosing_range_end [..] T8#C1#
 end
#  ⌃ enclosing_range_end [..] T8#
 
 # Definition in module included via superclass & superclass only
 
#⌄ enclosing_range_start [..] T9#
 module T9
#       ^^ definition [..] T9#
#  ⌄ enclosing_range_start [..] T9#M#
   module M
#         ^ definition [..] T9#M#
#    ⌄ enclosing_range_start [..] T9#M#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T9#M#set_f_0().
#                 ^^ definition [..] T9#M#`@f`.
#                 ^^^^^^ reference [..] T9#M#`@f`.
#                           ⌃ enclosing_range_end [..] T9#M#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T9#M#
 
#  ⌄ enclosing_range_start [..] T9#C0#
   class C0
#        ^^ definition [..] T9#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T9#M#
#            ^ reference [..] T9#M#
#    ⌄ enclosing_range_start [..] T9#C0#set_f_1().
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T9#C0#set_f_1().
#                 ^^ definition [..] T9#C0#`@f`.
#                 relation reference=[..] T9#M#`@f`.
#                 ^^^^^^ reference [..] T9#C0#`@f`.
#                           ⌃ enclosing_range_end [..] T9#C0#set_f_1().
   end
#    ⌃ enclosing_range_end [..] T9#C0#
 
#  ⌄ enclosing_range_start [..] T9#C1#
   class C1 < C0
#        ^^ definition [..] T9#C1#
#             ^^ reference [..] T9#C0#
#    ⌄ enclosing_range_start [..] T9#C1#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T9#C1#get_f().
#               ^^ reference [..] T9#C1#`@f`.
#               relation definition=[..] T9#C0#`@f`.
#                     ⌃ enclosing_range_end [..] T9#C1#get_f().
   end
#    ⌃ enclosing_range_end [..] T9#C1#
 end
#  ⌃ enclosing_range_end [..] T9#
 
 # Definition in module included via superclass & Self
 
#⌄ enclosing_range_start [..] T10#
 module T10
#       ^^^ definition [..] T10#
#  ⌄ enclosing_range_start [..] T10#M#
   module M
#         ^ definition [..] T10#M#
#    ⌄ enclosing_range_start [..] T10#M#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T10#M#set_f_0().
#                 ^^ definition [..] T10#M#`@f`.
#                 ^^^^^^ reference [..] T10#M#`@f`.
#                           ⌃ enclosing_range_end [..] T10#M#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T10#M#
 
#  ⌄ enclosing_range_start [..] T10#C0#
   class C0
#        ^^ definition [..] T10#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T10#M#
#            ^ reference [..] T10#M#
   end
#    ⌃ enclosing_range_end [..] T10#C0#
 
#  ⌄ enclosing_range_start [..] T10#C1#
   class C1 < C0
#        ^^ definition [..] T10#C1#
#             ^^ reference [..] T10#C0#
#    ⌄ enclosing_range_start [..] T10#C1#set_f_2().
     def set_f_2; @f = 2; end
#        ^^^^^^^ definition [..] T10#C1#set_f_2().
#                 ^^ definition [..] T10#C1#`@f`.
#                 ^^^^^^ reference [..] T10#C1#`@f`.
#                           ⌃ enclosing_range_end [..] T10#C1#set_f_2().
#    ⌄ enclosing_range_start [..] T10#C1#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T10#C1#get_f().
#               ^^ reference [..] T10#C1#`@f`.
#                     ⌃ enclosing_range_end [..] T10#C1#get_f().
   end
#    ⌃ enclosing_range_end [..] T10#C1#
 end
#  ⌃ enclosing_range_end [..] T10#
 
 # Definition in module included via superclass only
 
#⌄ enclosing_range_start [..] T11#
 module T11
#       ^^^ definition [..] T11#
#  ⌄ enclosing_range_start [..] T11#M#
   module M
#         ^ definition [..] T11#M#
#    ⌄ enclosing_range_start [..] T11#M#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T11#M#set_f_0().
#                 ^^ definition [..] T11#M#`@f`.
#                 ^^^^^^ reference [..] T11#M#`@f`.
#                           ⌃ enclosing_range_end [..] T11#M#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T11#M#
 
#  ⌄ enclosing_range_start [..] T11#C0#
   class C0
#        ^^ definition [..] T11#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T11#M#
#            ^ reference [..] T11#M#
   end
#    ⌃ enclosing_range_end [..] T11#C0#
 
#  ⌄ enclosing_range_start [..] T11#C1#
   class C1 < C0
#        ^^ definition [..] T11#C1#
#             ^^ reference [..] T11#C0#
#    ⌄ enclosing_range_start [..] T11#C1#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T11#C1#get_f().
#               ^^ reference [..] T11#C1#`@f`.
#                     ⌃ enclosing_range_end [..] T11#C1#get_f().
   end
#    ⌃ enclosing_range_end [..] T11#C1#
 end
#  ⌃ enclosing_range_end [..] T11#
 
 # Definition in multiple transitively included modules & common child & Self
 
#⌄ enclosing_range_start [..] T12#
 module T12
#       ^^^ definition [..] T12#
#  ⌄ enclosing_range_start [..] T12#M0#
   module M0
#         ^^ definition [..] T12#M0#
#    ⌄ enclosing_range_start [..] T12#M0#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T12#M0#set_f_0().
#                 ^^ definition [..] T12#M0#`@f`.
#                 ^^^^^^ reference [..] T12#M0#`@f`.
#                           ⌃ enclosing_range_end [..] T12#M0#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T12#M0#
 
#  ⌄ enclosing_range_start [..] T12#M1#
   module M1
#         ^^ definition [..] T12#M1#
#    ⌄ enclosing_range_start [..] T12#M1#set_f_1().
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T12#M1#set_f_1().
#                 ^^ definition [..] T12#M1#`@f`.
#                 ^^^^^^ reference [..] T12#M1#`@f`.
#                           ⌃ enclosing_range_end [..] T12#M1#set_f_1().
   end
#    ⌃ enclosing_range_end [..] T12#M1#
 
#  ⌄ enclosing_range_start [..] T12#M2#
   module M2
#         ^^ definition [..] T12#M2#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T12#M0#
#            ^^ reference [..] T12#M0#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T12#M1#
#            ^^ reference [..] T12#M1#
#    ⌄ enclosing_range_start [..] T12#M2#set_f_2().
     def set_f_2; @f = 2; end
#        ^^^^^^^ definition [..] T12#M2#set_f_2().
#                 ^^ definition [..] T12#M2#`@f`.
#                 relation reference=[..] T12#M0#`@f`. reference=[..] T12#M1#`@f`.
#                 ^^^^^^ reference [..] T12#M2#`@f`.
#                           ⌃ enclosing_range_end [..] T12#M2#set_f_2().
   end
#    ⌃ enclosing_range_end [..] T12#M2#
 
#  ⌄ enclosing_range_start [..] T12#C#
   class C
#        ^ definition [..] T12#C#
     include M2
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T12#M2#
#            ^^ reference [..] T12#M2#
#    ⌄ enclosing_range_start [..] T12#C#set_f_3().
     def set_f_3; @f = 3; end
#        ^^^^^^^ definition [..] T12#C#set_f_3().
#                 ^^ definition [..] T12#C#`@f`.
#                 relation reference=[..] T12#M0#`@f`. reference=[..] T12#M1#`@f`. reference=[..] T12#M2#`@f`.
#                 ^^^^^^ reference [..] T12#C#`@f`.
#                           ⌃ enclosing_range_end [..] T12#C#set_f_3().
#    ⌄ enclosing_range_start [..] T12#C#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T12#C#get_f().
#               ^^ reference [..] T12#C#`@f`.
#                     ⌃ enclosing_range_end [..] T12#C#get_f().
   end
#    ⌃ enclosing_range_end [..] T12#C#
 end
#  ⌃ enclosing_range_end [..] T12#
 
 # Definition in multiple transitively included modules & common child only
 
#⌄ enclosing_range_start [..] T13#
 module T13
#       ^^^ definition [..] T13#
#  ⌄ enclosing_range_start [..] T13#M0#
   module M0
#         ^^ definition [..] T13#M0#
#    ⌄ enclosing_range_start [..] T13#M0#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T13#M0#set_f_0().
#                 ^^ definition [..] T13#M0#`@f`.
#                 ^^^^^^ reference [..] T13#M0#`@f`.
#                           ⌃ enclosing_range_end [..] T13#M0#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T13#M0#
 
#  ⌄ enclosing_range_start [..] T13#M1#
   module M1
#         ^^ definition [..] T13#M1#
#    ⌄ enclosing_range_start [..] T13#M1#set_f_1().
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T13#M1#set_f_1().
#                 ^^ definition [..] T13#M1#`@f`.
#                 ^^^^^^ reference [..] T13#M1#`@f`.
#                           ⌃ enclosing_range_end [..] T13#M1#set_f_1().
   end
#    ⌃ enclosing_range_end [..] T13#M1#
 
#  ⌄ enclosing_range_start [..] T13#M2#
   module M2
#         ^^ definition [..] T13#M2#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T13#M0#
#            ^^ reference [..] T13#M0#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T13#M1#
#            ^^ reference [..] T13#M1#
#    ⌄ enclosing_range_start [..] T13#M2#set_f_2().
     def set_f_2; @f = 2; end
#        ^^^^^^^ definition [..] T13#M2#set_f_2().
#                 ^^ definition [..] T13#M2#`@f`.
#                 relation reference=[..] T13#M0#`@f`. reference=[..] T13#M1#`@f`.
#                 ^^^^^^ reference [..] T13#M2#`@f`.
#                           ⌃ enclosing_range_end [..] T13#M2#set_f_2().
   end
#    ⌃ enclosing_range_end [..] T13#M2#
 
#  ⌄ enclosing_range_start [..] T13#C#
   class C
#        ^ definition [..] T13#C#
     include M2
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T13#M2#
#            ^^ reference [..] T13#M2#
#    ⌄ enclosing_range_start [..] T13#C#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T13#C#get_f().
#               ^^ reference [..] T13#C#`@f`.
#                     ⌃ enclosing_range_end [..] T13#C#get_f().
   end
#    ⌃ enclosing_range_end [..] T13#C#
 end
#  ⌃ enclosing_range_end [..] T13#
 
 # Definition in multiple transitively included modules & Self
 
#⌄ enclosing_range_start [..] T14#
 module T14
#       ^^^ definition [..] T14#
#  ⌄ enclosing_range_start [..] T14#M0#
   module M0
#         ^^ definition [..] T14#M0#
#    ⌄ enclosing_range_start [..] T14#M0#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T14#M0#set_f_0().
#                 ^^ definition [..] T14#M0#`@f`.
#                 ^^^^^^ reference [..] T14#M0#`@f`.
#                           ⌃ enclosing_range_end [..] T14#M0#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T14#M0#
 
#  ⌄ enclosing_range_start [..] T14#M1#
   module M1
#         ^^ definition [..] T14#M1#
#    ⌄ enclosing_range_start [..] T14#M1#set_f_1().
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T14#M1#set_f_1().
#                 ^^ definition [..] T14#M1#`@f`.
#                 ^^^^^^ reference [..] T14#M1#`@f`.
#                           ⌃ enclosing_range_end [..] T14#M1#set_f_1().
   end
#    ⌃ enclosing_range_end [..] T14#M1#
 
#  ⌄ enclosing_range_start [..] T14#M2#
   module M2
#         ^^ definition [..] T14#M2#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T14#M0#
#            ^^ reference [..] T14#M0#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T14#M1#
#            ^^ reference [..] T14#M1#
   end
#    ⌃ enclosing_range_end [..] T14#M2#
 
#  ⌄ enclosing_range_start [..] T14#C#
   class C
#        ^ definition [..] T14#C#
     include M2
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T14#M2#
#            ^^ reference [..] T14#M2#
#    ⌄ enclosing_range_start [..] T14#C#set_f_3().
     def set_f_3; @f = 3; end
#        ^^^^^^^ definition [..] T14#C#set_f_3().
#                 ^^ definition [..] T14#C#`@f`.
#                 relation reference=[..] T14#M0#`@f`. reference=[..] T14#M1#`@f`.
#                 ^^^^^^ reference [..] T14#C#`@f`.
#                           ⌃ enclosing_range_end [..] T14#C#set_f_3().
#    ⌄ enclosing_range_start [..] T14#C#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T14#C#get_f().
#               ^^ reference [..] T14#C#`@f`.
#                     ⌃ enclosing_range_end [..] T14#C#get_f().
   end
#    ⌃ enclosing_range_end [..] T14#C#
 end
#  ⌃ enclosing_range_end [..] T14#
 
 # Definition in multiple transitively included modules only
 
#⌄ enclosing_range_start [..] T15#
 module T15
#       ^^^ definition [..] T15#
#  ⌄ enclosing_range_start [..] T15#M0#
   module M0
#         ^^ definition [..] T15#M0#
#    ⌄ enclosing_range_start [..] T15#M0#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T15#M0#set_f_0().
#                 ^^ definition [..] T15#M0#`@f`.
#                 ^^^^^^ reference [..] T15#M0#`@f`.
#                           ⌃ enclosing_range_end [..] T15#M0#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T15#M0#
 
#  ⌄ enclosing_range_start [..] T15#M1#
   module M1
#         ^^ definition [..] T15#M1#
#    ⌄ enclosing_range_start [..] T15#M1#set_f_1().
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T15#M1#set_f_1().
#                 ^^ definition [..] T15#M1#`@f`.
#                 ^^^^^^ reference [..] T15#M1#`@f`.
#                           ⌃ enclosing_range_end [..] T15#M1#set_f_1().
   end
#    ⌃ enclosing_range_end [..] T15#M1#
 
#  ⌄ enclosing_range_start [..] T15#M2#
   module M2
#         ^^ definition [..] T15#M2#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T15#M0#
#            ^^ reference [..] T15#M0#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T15#M1#
#            ^^ reference [..] T15#M1#
   end
#    ⌃ enclosing_range_end [..] T15#M2#
 
#  ⌄ enclosing_range_start [..] T15#C#
   class C
#        ^ definition [..] T15#C#
     include M2
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T15#M2#
#            ^^ reference [..] T15#M2#
#    ⌄ enclosing_range_start [..] T15#C#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T15#C#get_f().
#               ^^ reference [..] T15#C#`@f`.
#                     ⌃ enclosing_range_end [..] T15#C#get_f().
   end
#    ⌃ enclosing_range_end [..] T15#C#
 end
#  ⌃ enclosing_range_end [..] T15#
 
 # Definition in multiple directly included modules & Self
 
#⌄ enclosing_range_start [..] T16#
 module T16
#       ^^^ definition [..] T16#
#  ⌄ enclosing_range_start [..] T16#M0#
   module M0
#         ^^ definition [..] T16#M0#
#    ⌄ enclosing_range_start [..] T16#M0#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T16#M0#set_f_0().
#                 ^^ definition [..] T16#M0#`@f`.
#                 ^^^^^^ reference [..] T16#M0#`@f`.
#                           ⌃ enclosing_range_end [..] T16#M0#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T16#M0#
 
#  ⌄ enclosing_range_start [..] T16#M1#
   module M1
#         ^^ definition [..] T16#M1#
#    ⌄ enclosing_range_start [..] T16#M1#set_f_1().
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T16#M1#set_f_1().
#                 ^^ definition [..] T16#M1#`@f`.
#                 ^^^^^^ reference [..] T16#M1#`@f`.
#                           ⌃ enclosing_range_end [..] T16#M1#set_f_1().
   end
#    ⌃ enclosing_range_end [..] T16#M1#
 
#  ⌄ enclosing_range_start [..] T16#C#
   class C
#        ^ definition [..] T16#C#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T16#M0#
#            ^^ reference [..] T16#M0#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T16#M1#
#            ^^ reference [..] T16#M1#
#    ⌄ enclosing_range_start [..] T16#C#set_f_2().
     def set_f_2; @f = 2; end
#        ^^^^^^^ definition [..] T16#C#set_f_2().
#                 ^^ definition [..] T16#C#`@f`.
#                 relation reference=[..] T16#M0#`@f`. reference=[..] T16#M1#`@f`.
#                 ^^^^^^ reference [..] T16#C#`@f`.
#                           ⌃ enclosing_range_end [..] T16#C#set_f_2().
#    ⌄ enclosing_range_start [..] T16#C#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T16#C#get_f().
#               ^^ reference [..] T16#C#`@f`.
#                     ⌃ enclosing_range_end [..] T16#C#get_f().
   end
#    ⌃ enclosing_range_end [..] T16#C#
 end
#  ⌃ enclosing_range_end [..] T16#
 
 # Definition in multiple directly included modules only
 
#⌄ enclosing_range_start [..] T17#
 module T17
#       ^^^ definition [..] T17#
#  ⌄ enclosing_range_start [..] T17#M0#
   module M0
#         ^^ definition [..] T17#M0#
#    ⌄ enclosing_range_start [..] T17#M0#set_f_0().
     def set_f_0; @f = 0; end
#        ^^^^^^^ definition [..] T17#M0#set_f_0().
#                 ^^ definition [..] T17#M0#`@f`.
#                 ^^^^^^ reference [..] T17#M0#`@f`.
#                           ⌃ enclosing_range_end [..] T17#M0#set_f_0().
   end
#    ⌃ enclosing_range_end [..] T17#M0#
 
#  ⌄ enclosing_range_start [..] T17#M1#
   module M1
#         ^^ definition [..] T17#M1#
#    ⌄ enclosing_range_start [..] T17#M1#set_f_1().
     def set_f_1; @f = 1; end
#        ^^^^^^^ definition [..] T17#M1#set_f_1().
#                 ^^ definition [..] T17#M1#`@f`.
#                 ^^^^^^ reference [..] T17#M1#`@f`.
#                           ⌃ enclosing_range_end [..] T17#M1#set_f_1().
   end
#    ⌃ enclosing_range_end [..] T17#M1#
 
#  ⌄ enclosing_range_start [..] T17#C#
   class C
#        ^ definition [..] T17#C#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T17#M0#
#            ^^ reference [..] T17#M0#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] T17#M1#
#            ^^ reference [..] T17#M1#
#    ⌄ enclosing_range_start [..] T17#C#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] T17#C#get_f().
#               ^^ reference [..] T17#C#`@f`.
#                     ⌃ enclosing_range_end [..] T17#C#get_f().
   end
#    ⌃ enclosing_range_end [..] T17#C#
 end
#  ⌃ enclosing_range_end [..] T17#
 
 # OKAY! Now for the more "weird" situations
 # Before this, all the tests had a definition come "before" use.
 # Let's see what happens if there is a use before any definition.
 
 # Reference in directly included module with def in Self
 
#⌄ enclosing_range_start [..] W0#
 module W0
#       ^^ definition [..] W0#
#  ⌄ enclosing_range_start [..] W0#M#
   module M
#         ^ definition [..] W0#M#
#    ⌄ enclosing_range_start [..] W0#M#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] W0#M#get_f().
#               ^^ reference [..] W0#M#`@f`.
#                     ⌃ enclosing_range_end [..] W0#M#get_f().
   end
#    ⌃ enclosing_range_end [..] W0#M#
 
#  ⌄ enclosing_range_start [..] W0#C#
   class C
#        ^ definition [..] W0#C#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] W0#M#
#            ^ reference [..] W0#M#
#    ⌄ enclosing_range_start [..] W0#C#set_f().
     def set_f; @f = 0; end
#        ^^^^^ definition [..] W0#C#set_f().
#               ^^ definition [..] W0#C#`@f`.
#               relation reference=[..] W0#M#`@f`.
#               ^^^^^^ reference [..] W0#C#`@f`.
#                         ⌃ enclosing_range_end [..] W0#C#set_f().
   end
#    ⌃ enclosing_range_end [..] W0#C#
 end
#  ⌃ enclosing_range_end [..] W0#
 
 # Reference in transitively included module with def in Self
 
#⌄ enclosing_range_start [..] W1#
 module W1
#       ^^ definition [..] W1#
#  ⌄ enclosing_range_start [..] W1#M0#
   module M0
#         ^^ definition [..] W1#M0#
#    ⌄ enclosing_range_start [..] W1#M0#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] W1#M0#get_f().
#               ^^ reference [..] W1#M0#`@f`.
#                     ⌃ enclosing_range_end [..] W1#M0#get_f().
   end
#    ⌃ enclosing_range_end [..] W1#M0#
   
#  ⌄ enclosing_range_start [..] W1#M1#
   module M1
#         ^^ definition [..] W1#M1#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] W1#M0#
#            ^^ reference [..] W1#M0#
   end
#    ⌃ enclosing_range_end [..] W1#M1#
 
#  ⌄ enclosing_range_start [..] W1#C#
   class C
#        ^ definition [..] W1#C#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] W1#M1#
#            ^^ reference [..] W1#M1#
#    ⌄ enclosing_range_start [..] W1#C#set_f().
     def set_f; @f = 0; end
#        ^^^^^ definition [..] W1#C#set_f().
#               ^^ definition [..] W1#C#`@f`.
#               relation reference=[..] W1#M0#`@f`.
#               ^^^^^^ reference [..] W1#C#`@f`.
#                         ⌃ enclosing_range_end [..] W1#C#set_f().
   end
#    ⌃ enclosing_range_end [..] W1#C#
 end
#  ⌃ enclosing_range_end [..] W1#
 
 # Reference in superclass with def in directly included module
 
#⌄ enclosing_range_start [..] W2#
 module W2
#       ^^ definition [..] W2#
#  ⌄ enclosing_range_start [..] W2#M#
   module M
#         ^ definition [..] W2#M#
#    ⌄ enclosing_range_start [..] W2#M#set_f().
     def set_f; @f = 0; end
#        ^^^^^ definition [..] W2#M#set_f().
#               ^^ definition [..] W2#M#`@f`.
#               ^^^^^^ reference [..] W2#M#`@f`.
#                         ⌃ enclosing_range_end [..] W2#M#set_f().
   end
#    ⌃ enclosing_range_end [..] W2#M#
 
#  ⌄ enclosing_range_start [..] W2#C0#
   class C0
#        ^^ definition [..] W2#C0#
#    ⌄ enclosing_range_start [..] W2#C0#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] W2#C0#get_f().
#               ^^ reference [..] W2#C0#`@f`.
#                     ⌃ enclosing_range_end [..] W2#C0#get_f().
   end
#    ⌃ enclosing_range_end [..] W2#C0#
 
#  ⌄ enclosing_range_start [..] W2#C1#
   class C1 < C0
#        ^^ definition [..] W2#C1#
#             ^^ reference [..] W2#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] W2#M#
#            ^ reference [..] W2#M#
#    ⌄ enclosing_range_start [..] W2#C1#get_fp1().
     def get_fp1; @f + 1; end
#        ^^^^^^^ definition [..] W2#C1#get_fp1().
#                 ^^ reference [..] W2#C1#`@f`.
#                 relation definition=[..] W2#C0#`@f`. reference=[..] W2#M#`@f`.
#                           ⌃ enclosing_range_end [..] W2#C1#get_fp1().
   end
#    ⌃ enclosing_range_end [..] W2#C1#
 end
#  ⌃ enclosing_range_end [..] W2#
 
 # Reference in directly included module with def in superclass
 
#⌄ enclosing_range_start [..] W3#
 module W3
#       ^^ definition [..] W3#
#  ⌄ enclosing_range_start [..] W3#M#
   module M
#         ^ definition [..] W3#M#
#    ⌄ enclosing_range_start [..] W3#M#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] W3#M#get_f().
#               ^^ reference [..] W3#M#`@f`.
#                     ⌃ enclosing_range_end [..] W3#M#get_f().
   end
#    ⌃ enclosing_range_end [..] W3#M#
 
#  ⌄ enclosing_range_start [..] W3#C0#
   class C0
#        ^^ definition [..] W3#C0#
#    ⌄ enclosing_range_start [..] W3#C0#set_f().
     def set_f; @f = 0; end
#        ^^^^^ definition [..] W3#C0#set_f().
#               ^^ definition [..] W3#C0#`@f`.
#               ^^^^^^ reference [..] W3#C0#`@f`.
#                         ⌃ enclosing_range_end [..] W3#C0#set_f().
   end
#    ⌃ enclosing_range_end [..] W3#C0#
 
#  ⌄ enclosing_range_start [..] W3#C1#
   class C1 < C0
#        ^^ definition [..] W3#C1#
#             ^^ reference [..] W3#C0#
     include M
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] W3#M#
#            ^ reference [..] W3#M#
#    ⌄ enclosing_range_start [..] W3#C1#get_fp1().
     def get_fp1; @f + 1; end
#        ^^^^^^^ definition [..] W3#C1#get_fp1().
#                 ^^ reference [..] W3#C1#`@f`.
#                 relation definition=[..] W3#C0#`@f`. reference=[..] W3#M#`@f`.
#                           ⌃ enclosing_range_end [..] W3#C1#get_fp1().
   end
#    ⌃ enclosing_range_end [..] W3#C1#
 end
#  ⌃ enclosing_range_end [..] W3#
 
 # Reference in transitively included module with def in in-between module
 
#⌄ enclosing_range_start [..] W4#
 module W4
#       ^^ definition [..] W4#
#  ⌄ enclosing_range_start [..] W4#M0#
   module M0
#         ^^ definition [..] W4#M0#
#    ⌄ enclosing_range_start [..] W4#M0#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] W4#M0#get_f().
#               ^^ reference [..] W4#M0#`@f`.
#                     ⌃ enclosing_range_end [..] W4#M0#get_f().
   end
#    ⌃ enclosing_range_end [..] W4#M0#
 
#  ⌄ enclosing_range_start [..] W4#M1#
   module M1
#         ^^ definition [..] W4#M1#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] W4#M0#
#            ^^ reference [..] W4#M0#
#    ⌄ enclosing_range_start [..] W4#M1#set_f().
     def set_f; @f = 0; end
#        ^^^^^ definition [..] W4#M1#set_f().
#               ^^ definition [..] W4#M1#`@f`.
#               relation reference=[..] W4#M0#`@f`.
#               ^^^^^^ reference [..] W4#M1#`@f`.
#                         ⌃ enclosing_range_end [..] W4#M1#set_f().
   end
#    ⌃ enclosing_range_end [..] W4#M1#
 
#  ⌄ enclosing_range_start [..] W4#C#
   class C
#        ^ definition [..] W4#C#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] W4#M1#
#            ^^ reference [..] W4#M1#
#    ⌄ enclosing_range_start [..] W4#C#get_fp1().
     def get_fp1; @f + 1; end
#        ^^^^^^^ definition [..] W4#C#get_fp1().
#                 ^^ reference [..] W4#C#`@f`.
#                           ⌃ enclosing_range_end [..] W4#C#get_fp1().
   end
#    ⌃ enclosing_range_end [..] W4#C#
 end
#  ⌃ enclosing_range_end [..] W4#
 
 # Reference in one directly included module with def in other directly included module
 
#⌄ enclosing_range_start [..] W5#
 module W5
#       ^^ definition [..] W5#
#  ⌄ enclosing_range_start [..] W5#M0#
   module M0
#         ^^ definition [..] W5#M0#
#    ⌄ enclosing_range_start [..] W5#M0#get_f().
     def get_f; @f; end
#        ^^^^^ definition [..] W5#M0#get_f().
#               ^^ reference [..] W5#M0#`@f`.
#                     ⌃ enclosing_range_end [..] W5#M0#get_f().
   end
#    ⌃ enclosing_range_end [..] W5#M0#
 
#  ⌄ enclosing_range_start [..] W5#M1#
   module M1
#         ^^ definition [..] W5#M1#
#    ⌄ enclosing_range_start [..] W5#M1#set_f().
     def set_f; @f + 1; end
#        ^^^^^ definition [..] W5#M1#set_f().
#               ^^ reference [..] W5#M1#`@f`.
#                         ⌃ enclosing_range_end [..] W5#M1#set_f().
   end
#    ⌃ enclosing_range_end [..] W5#M1#
 
#  ⌄ enclosing_range_start [..] W5#C#
   class C
#        ^ definition [..] W5#C#
     include M0
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] W5#M0#
#            ^^ reference [..] W5#M0#
     include M1
#    ^^^^^^^ reference [..] Module#include().
#            ^^ reference [..] W5#M1#
#            ^^ reference [..] W5#M1#
#    ⌄ enclosing_range_start [..] W5#C#get_fp1().
     def get_fp1; @f + 1; end
#        ^^^^^^^ definition [..] W5#C#get_fp1().
#                 ^^ reference [..] W5#C#`@f`.
#                           ⌃ enclosing_range_end [..] W5#C#get_fp1().
   end
#    ⌃ enclosing_range_end [..] W5#C#
 end
#  ⌃ enclosing_range_end [..] W5#
