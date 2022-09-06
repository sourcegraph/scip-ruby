 # typed: true
 
 _ = 0
#^ definition local 1~#119448696
 
 class C1
#      ^^ definition [..] C1#
   def f()
#      ^ definition [..] C1#f().
     _a = C1.new
#    ^^ definition local 1~#3809224601
#         ^^ reference [..] C1#
     _b = M2::C2.new
#    ^^ definition local 3~#3809224601
#         ^^ reference [..] M2#
#             ^^ reference [..] M2#C2#
     return
   end
 end
 
 module M2
#       ^^ definition [..] M2#
   class C2
#        ^^ definition [..] M2#C2#
   end
 end
 
 class M3::C3
#      ^^ reference [..] M3#
#          ^^ definition [..] M3#C3#
 end
 
 def local_class()
#    ^^^^^^^^^^^ definition [..] Object#local_class().
   localClass = Class.new
#  ^^^^^^^^^^ definition local 1~#552113551
#               ^^^^^ reference [..] Class#
   # Technically, this is not supported by Sorbet (https://srb.help/3001),
   # but make sure we don't crash or do something weird.
   def localClass.myMethod()
#                 ^^^^^^^^ definition [..] Object#myMethod().
     ":)"
   end
   _c = localClass.new
#  ^^ definition local 3~#552113551
#       ^^^^^^^^^^ reference local 1~#552113551
#                  ^^^ reference [..] Class#new().
   # TODO: Missing occurrence for myMethod
   _m = localClass.myMethod
#  ^^ definition local 4~#552113551
#       ^^^^^^^^^^ reference local 1~#552113551
   return
 end
 
 module M4
#       ^^ definition [..] M4#
   K = 0
#  ^ definition [..] M4#K.
#  ^^^^^ reference [..] M4#K.
 end
 
 def module_access()
#    ^^^^^^^^^^^^^ definition [..] Object#module_access().
   _ = M4::K
#  ^ definition local 1~#3353511840
#      ^^ reference [..] M4#
#          ^ reference [..] M4#K.
   return
 end
 
 module M5
#       ^^ definition [..] M5#
   module M6
#         ^^ definition [..] M5#M6#
     def self.g()
#             ^ definition [..] M5#`<Class:M6>`#g().
     end
   end
 
   def self.h()
#           ^ definition [..] `<Class:M5>`#h().
     M6.g()
#    ^^ reference [..] M5#M6#
#       ^ reference [..] M5#`<Class:M6>`#g().
     return
   end
 end
 
 class C7
#      ^^ definition [..] C7#
   module M8
#         ^^ definition [..] C7#M8#
     def self.i()
#             ^ definition [..] C7#`<Class:M8>`#i().
     end
   end
 
   def j()
#      ^ definition [..] C7#j().
     M8.i()
#    ^^ reference [..] C7#M8#
#       ^ reference [..] C7#`<Class:M8>`#i().
     return
   end
 end
