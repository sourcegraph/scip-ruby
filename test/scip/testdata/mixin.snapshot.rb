 # typed: true
 
 module M
#       ^ definition [..] M#
   def f
#      ^ definition [..] M#f().
     puts 'M.f'
   end
 end
 
 class C1
#      ^^ definition [..] C1#
   include M
#  ^^^^^^^ reference [..] Module#include().
#          ^ reference [..] M#
   def f
#      ^ definition [..] C1#f().
     puts 'C1.f'
#    ^^^^ reference [..] Kernel#puts().
   end
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
   def f
#      ^ definition [..] D1#f().
     puts 'D1.f'
#    ^^^^ reference [..] Kernel#puts().
   end
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
