 # typed: true
 
 _ = 0
#^ definition local 1~#119448696
 
 class C1
#      ^^ definition scip-ruby gem TODO TODO C1#
   def f()
#  ^^^^^^^ definition scip-ruby gem TODO TODO C1#f().
     _a = C1.new
#    ^^ definition local 1~#3809224601
#         ^^ reference scip-ruby gem TODO TODO C1#
     _b = M2::C2.new
#    ^^ definition local 3~#3809224601
#         ^^ reference scip-ruby gem TODO TODO M2#
#             ^^ reference scip-ruby gem TODO TODO M2#C2#
     return
   end
 end
 
 module M2
#       ^^ definition scip-ruby gem TODO TODO M2#
   class C2
#        ^^ definition scip-ruby gem TODO TODO M2#C2#
   end
 end
 
 class M3::C3
#      ^^ reference scip-ruby gem TODO TODO M3#
#          ^^ definition scip-ruby gem TODO TODO M3#C3#
 end
 
 def local_class()
#^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO Object#local_class().
   localClass = Class.new
#  ^^^^^^^^^^ definition local 1~#552113551
#               ^^^^^ reference scip-ruby gem TODO TODO Class#
   # Technically, this is not supported by Sorbet (https://srb.help/3001),
   # but make sure we don't crash or do something weird.
   def localClass.myMethod()
#  ^^^^^^^^^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO Object#myMethod().
     ":)"
   end
   _c = localClass.new
#  ^^ definition local 3~#552113551
#       ^^^^^^^^^^ reference local 1~#552113551
   _m = localClass.myMethod
#  ^^ definition local 4~#552113551
#       ^^^^^^^^^^ reference local 1~#552113551
#                  ^^^^^^^^ reference scip-ruby gem TODO TODO Object#myMethod().
   return
 end
 
 module M4
#       ^^ definition scip-ruby gem TODO TODO M4#
   K = 0
#  ^ definition scip-ruby gem TODO TODO M4#K.
#  ^^^^^ reference scip-ruby gem TODO TODO M4#K.
 end
 
 def module_access()
#^^^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO Object#module_access().
   _ = M4::K
#  ^ definition local 1~#3353511840
#      ^^ reference scip-ruby gem TODO TODO M4#
#          ^ reference scip-ruby gem TODO TODO M4#K.
   return
 end
 
 module M5
#       ^^ definition scip-ruby gem TODO TODO M5#
   module M6
#         ^^ definition scip-ruby gem TODO TODO M5#M6#
     def self.g()
#    ^^^^^^^^^^^^ definition scip-ruby gem TODO TODO M5#<Class:M6>#g().
     end
   end
 
   def self.h()
#  ^^^^^^^^^^^^ definition scip-ruby gem TODO TODO <Class:M5>#h().
     M6.g()
#    ^^ reference scip-ruby gem TODO TODO M5#M6#
     return
   end
 end
 
 class C7
#      ^^ definition scip-ruby gem TODO TODO C7#
   module M8
#         ^^ definition scip-ruby gem TODO TODO C7#M8#
     def self.i()
#    ^^^^^^^^^^^^ definition scip-ruby gem TODO TODO C7#<Class:M8>#i().
     end
   end
 
   def j()
#  ^^^^^^^ definition scip-ruby gem TODO TODO C7#j().
     M8.j()
#    ^^ reference scip-ruby gem TODO TODO C7#M8#
#       ^ reference scip-ruby gem TODO TODO C7#j().
     return
   end
 end
