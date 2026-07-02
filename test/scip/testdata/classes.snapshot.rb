 # typed: true
 
 _ = 0
#^ definition local 1$119448696
 
#⌄ enclosing_range_start [..] C1#
 class C1
#      ^^ definition [..] C1#
#  ⌄ enclosing_range_start [..] C1#f().
   def f()
#      ^ definition [..] C1#f().
     _a = C1.new
#    ^^ definition local 1$3809224601
#         ^^ reference [..] C1#
#            ^^^ reference [..] Class#new().
     _b = M2::C2.new
#    ^^ definition local 3$3809224601
#         ^^ reference [..] M2#
#             ^^ reference [..] M2#C2#
#                ^^^ reference [..] Class#new().
     return
   end
#    ⌃ enclosing_range_end [..] C1#f().
 end
#  ⌃ enclosing_range_end [..] C1#
 
#⌄ enclosing_range_start [..] M2#
 module M2
#       ^^ definition [..] M2#
#  ⌄ enclosing_range_start [..] M2#C2#
   class C2
#        ^^ definition [..] M2#C2#
   end
#    ⌃ enclosing_range_end [..] M2#C2#
 end
#  ⌃ enclosing_range_end [..] M2#
 
#⌄ enclosing_range_start [..] M3#C3#
 class M3::C3
#      ^^ reference [..] M3#
#          ^^ definition [..] M3#C3#
 end
#  ⌃ enclosing_range_end [..] M3#C3#
 
#⌄ enclosing_range_start [..] Object#local_class().
 def local_class()
#    ^^^^^^^^^^^ definition [..] Object#local_class().
   localClass = Class.new
#  ^^^^^^^^^^ definition local 1$552113551
#               ^^^^^ reference [..] Class#
#                     ^^^ reference [..] `<Class:Class>`#new().
   # Technically, this is not supported by Sorbet (https://srb.help/3001),
   # but make sure we don't crash or do something weird.
#  ⌄ enclosing_range_start [..] Object#myMethod().
   def localClass.myMethod()
#                 ^^^^^^^^ definition [..] Object#myMethod().
     ":)"
   end
#    ⌃ enclosing_range_end [..] Object#myMethod().
   _c = localClass.new
#  ^^ definition local 3$552113551
#       ^^^^^^^^^^ reference local 1$552113551
#                  ^^^ reference [..] Class#new().
   # TODO: Missing occurrence for myMethod
   _m = localClass.myMethod
#  ^^ definition local 4$552113551
#       ^^^^^^^^^^ reference local 1$552113551
#                  ^^^^^^^^ reference [..] Object#myMethod().
   return
 end
#  ⌃ enclosing_range_end [..] Object#local_class().
 
#⌄ enclosing_range_start [..] M4#
 module M4
#       ^^ definition [..] M4#
   K = 0
#  ^ definition [..] M4#K.
#  ^^^^^ reference [..] M4#K.
 end
#  ⌃ enclosing_range_end [..] M4#
 
#⌄ enclosing_range_start [..] Object#module_access().
 def module_access()
#    ^^^^^^^^^^^^^ definition [..] Object#module_access().
   _ = M4::K
#  ^ definition local 1$3353511840
#      ^^ reference [..] M4#
#          ^ reference [..] M4#K.
   return
 end
#  ⌃ enclosing_range_end [..] Object#module_access().
 
#⌄ enclosing_range_start [..] M5#
 module M5
#       ^^ definition [..] M5#
#  ⌄ enclosing_range_start [..] M5#M6#
   module M6
#         ^^ definition [..] M5#M6#
#    ⌄ enclosing_range_start [..] M5#`<Class:M6>`#g().
     def self.g()
#             ^ definition [..] M5#`<Class:M6>`#g().
     end
#      ⌃ enclosing_range_end [..] M5#`<Class:M6>`#g().
   end
#    ⌃ enclosing_range_end [..] M5#M6#
 
#  ⌄ enclosing_range_start [..] `<Class:M5>`#h().
   def self.h()
#           ^ definition [..] `<Class:M5>`#h().
     M6.g()
#    ^^ reference [..] M5#M6#
#       ^ reference [..] M5#`<Class:M6>`#g().
     return
   end
#    ⌃ enclosing_range_end [..] `<Class:M5>`#h().
 end
#  ⌃ enclosing_range_end [..] M5#
 
#⌄ enclosing_range_start [..] C7#
 class C7
#      ^^ definition [..] C7#
#  ⌄ enclosing_range_start [..] C7#M8#
   module M8
#         ^^ definition [..] C7#M8#
#    ⌄ enclosing_range_start [..] C7#`<Class:M8>`#i().
     def self.i()
#             ^ definition [..] C7#`<Class:M8>`#i().
     end
#      ⌃ enclosing_range_end [..] C7#`<Class:M8>`#i().
   end
#    ⌃ enclosing_range_end [..] C7#M8#
 
#  ⌄ enclosing_range_start [..] C7#j().
   def j()
#      ^ definition [..] C7#j().
     M8.i()
#    ^^ reference [..] C7#M8#
#       ^ reference [..] C7#`<Class:M8>`#i().
     return
   end
#    ⌃ enclosing_range_end [..] C7#j().
 end
#  ⌃ enclosing_range_end [..] C7#
