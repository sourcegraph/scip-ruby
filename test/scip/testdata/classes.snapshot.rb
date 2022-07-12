 # typed: true
 
 _ = 0
#^ definition local 1~#119448696
 
 class C1
#      ^^ definition scip-ruby gem TODO TODO C1#
   def f()
#  ^^^^^^^ definition scip-ruby gem TODO TODO f().
     _a = C1.new
#    ^^ definition local 2~#3809224601
#         ^^ reference scip-ruby gem TODO TODO C1#
     _b = M2::C2.new
#    ^^ definition local 5~#3809224601
#         ^^ reference scip-ruby gem TODO TODO M2#
#             ^^ reference scip-ruby gem TODO TODO C2#
     return
   end
 end
 
 module M2
#       ^^ definition scip-ruby gem TODO TODO M2#
   class C2
#        ^^ definition scip-ruby gem TODO TODO C2#
   end
 end
 
 class M3::C3
#      ^^ definition scip-ruby gem TODO TODO M3#
#          ^^ definition scip-ruby gem TODO TODO C3#
 end
 
 def local_class()
#^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO local_class().
   localClass = Class.new
#  ^^^^^^^^^^ definition local 2~#552113551
#               ^^^^^ reference scip-ruby gem TODO TODO Class#
   # Technically, this is not supported by Sorbet (https://srb.help/3001),
   # but make sure we don't crash or do something weird.
   def localClass.myMethod()
#  ^^^^^^^^^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO myMethod().
     ":)"
   end
   _c = localClass.new
#  ^^ definition local 3~#552113551
#       ^^^^^^^^^^ reference local 2~#552113551
   _m = localClass.myMethod
#  ^^ definition local 4~#552113551
#       ^^^^^^^^^^ reference local 2~#552113551
#                  ^^^^^^^^ reference scip-ruby gem TODO TODO myMethod().
   return
 end
 
 module M4
#       ^^ definition scip-ruby gem TODO TODO M4#
   K = 0
#  ^ definition local 1~#119448696
#  ^^^^^ reference local 1~#119448696
 end
 
 def module_access()
#^^^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO module_access().
   _ = M4::K
#  ^ definition local 2~#3353511840
#      ^^ reference scip-ruby gem TODO TODO M4#
#          ^ reference scip-ruby gem TODO TODO K.
   return
 end
 
 module M5
#       ^^ definition scip-ruby gem TODO TODO M5#
   module M6
#         ^^ definition scip-ruby gem TODO TODO M6#
     def self.g()
#    ^^^^^^^^^^^^ definition scip-ruby gem TODO TODO g().
     end
   end
 
   def self.h()
#  ^^^^^^^^^^^^ definition scip-ruby gem TODO TODO h().
     M6.g()
#    ^^ reference scip-ruby gem TODO TODO M6#
     return
   end
 end
 
 class C7
#      ^^ definition scip-ruby gem TODO TODO C7#
   module M8
#         ^^ definition scip-ruby gem TODO TODO M8#
     def self.i()
#    ^^^^^^^^^^^^ definition scip-ruby gem TODO TODO i().
     end
   end
 
   def j()
#  ^^^^^^^ definition scip-ruby gem TODO TODO j().
     M8.j()
#    ^^ reference scip-ruby gem TODO TODO M8#
#       ^ reference scip-ruby gem TODO TODO j().
     return
   end
 end
