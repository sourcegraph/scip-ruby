 # typed: strict
 
 # Exercises T::Helpers `requires_ancestor { ... }`.
 
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
   def name; end
#      ^^^^ definition [..] Greetable#name().
 
   sig { void }
   def greet
#      ^^^^^ definition [..] Greetable#greet().
     puts("Hello, " + name)
#                     ^^^^ reference [..] Greetable#name().
   end
 end
 
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
   def name
#      ^^^^ definition [..] GreetableClass#name().
     "World"
   end
 end
