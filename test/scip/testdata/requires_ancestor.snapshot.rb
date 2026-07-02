 # typed: strict
 
 # Exercises T::Helpers `requires_ancestor { ... }`.
 
#⌄ enclosing_range_start [..] Greetable#
 module Greetable
#       ^^^^^^^^^ definition [..] Greetable#
   extend T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   abstract!
 
   requires_ancestor { Kernel }
#                      ^^^^^^ reference [..] Kernel#
 
   sig { abstract.returns(String) }
#                         ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] Greetable#name().
   def name; end
#      ^^^^ definition [..] Greetable#name().
#              ⌃ enclosing_range_end [..] Greetable#name().
 
   sig { void }
#  ⌄ enclosing_range_start [..] Greetable#greet().
   def greet
#      ^^^^^ definition [..] Greetable#greet().
     puts("Hello, " + name)
#                     ^^^^ reference [..] Greetable#name().
   end
#    ⌃ enclosing_range_end [..] Greetable#greet().
 end
#  ⌃ enclosing_range_end [..] Greetable#
 
#⌄ enclosing_range_start [..] GreetableClass#
 class GreetableClass
#      ^^^^^^^^^^^^^^ definition [..] GreetableClass#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   include Greetable
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^^^ reference [..] Greetable#
#          ^^^^^^^^^ reference [..] Greetable#
 
   sig { override.returns(String) }
#                         ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] GreetableClass#name().
   def name
#      ^^^^ definition [..] GreetableClass#name().
     "World"
   end
#    ⌃ enclosing_range_end [..] GreetableClass#name().
 end
#  ⌃ enclosing_range_end [..] GreetableClass#
