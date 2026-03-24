 # typed: true
 
 # Useful SO discussion with examples for class variables and instance variables,
 # and how they interact with inheritance: https://stackoverflow.com/a/15773671/2682729
 
#⌄ enclosing_range_start [..] K#
 class K
#      ^ definition [..] K#
#  ⌄ enclosing_range_start [..] K#m1().
   def m1
#      ^^ definition [..] K#m1().
     @f = 0
#    ^^ definition [..] K#`@f`.
     @g = @f
#    ^^ definition [..] K#`@g`.
#         ^^ reference [..] K#`@f`.
     return
   end
#    ⌃ enclosing_range_end [..] K#m1().
#  ⌄ enclosing_range_start [..] K#m2().
   def m2
#      ^^ definition [..] K#m2().
     @f = @g
#    ^^ definition [..] K#`@f`.
#         ^^ reference [..] K#`@g`.
     return
   end
#    ⌃ enclosing_range_end [..] K#m2().
 end
#  ⌃ enclosing_range_end [..] K#
 
 # Extended
#⌄ enclosing_range_start [..] K#
 class K
#      ^ definition [..] K#
#  ⌄ enclosing_range_start [..] K#m3().
   def m3
#      ^^ definition [..] K#m3().
     @g = @f
#    ^^ definition [..] K#`@g`.
#         ^^ reference [..] K#`@f`.
     return
   end
#    ⌃ enclosing_range_end [..] K#m3().
 end
#  ⌃ enclosing_range_end [..] K#
 
 # Class instance var
#⌄ enclosing_range_start [..] L#
 class L
#      ^ definition [..] L#
   @x = 10
#  ^^ definition [..] `<Class:L>`#`@x`.
   @y = 9
#  ^^ definition [..] `<Class:L>`#`@y`.
#  ⌄ enclosing_range_start [..] `<Class:L>`#m1().
   def self.m1
#           ^^ definition [..] `<Class:L>`#m1().
     @y = @x
#    ^^ definition [..] `<Class:L>`#`@y`.
#         ^^ reference [..] `<Class:L>`#`@x`.
     return
   end
#    ⌃ enclosing_range_end [..] `<Class:L>`#m1().
 
#  ⌄ enclosing_range_start [..] L#m2().
   def m2
#      ^^ definition [..] L#m2().
     # FIXME: Missing references
     self.class.y = self.class.x
     return
   end
#    ⌃ enclosing_range_end [..] L#m2().
 end
#  ⌃ enclosing_range_end [..] L#
 
 # Class var
#⌄ enclosing_range_start [..] N#
 class N
#      ^ definition [..] N#
   @@a = 0
#  ^^^ definition [..] `<Class:N>`#`@@a`.
   @@b = 1
#  ^^^ definition [..] `<Class:N>`#`@@b`.
#  ⌄ enclosing_range_start [..] `<Class:N>`#m1().
   def self.m1
#           ^^ definition [..] `<Class:N>`#m1().
     @@b = @@a
#    ^^^ definition [..] `<Class:N>`#`@@b`.
#          ^^^ reference [..] `<Class:N>`#`@@a`.
     return
   end
#    ⌃ enclosing_range_end [..] `<Class:N>`#m1().
 
#  ⌄ enclosing_range_start [..] N#m2().
   def m2
#      ^^ definition [..] N#m2().
     @@b = @@a
#    ^^^ definition [..] `<Class:N>`#`@@b`.
#          ^^^ reference [..] `<Class:N>`#`@@a`.
     return
   end
#    ⌃ enclosing_range_end [..] N#m2().
 
#  ⌄ enclosing_range_start [..] N#m3().
   def m3
#      ^^ definition [..] N#m3().
     # FIXME: Missing references
     self.class.b = self.class.a
   end
#    ⌃ enclosing_range_end [..] N#m3().
 end
#  ⌃ enclosing_range_end [..] N#
 
 # Accessors
#⌄ enclosing_range_start [..] P#
 class P
#      ^ definition [..] P#
#  ⌄ enclosing_range_start [..] P#`a=`().
#  ⌄ enclosing_range_start [..] P#a().
   attr_accessor :a
#                 ^ definition [..] P#`a=`().
#                 ^ definition [..] P#a().
#                 ⌃ enclosing_range_end [..] P#`a=`().
#                 ⌃ enclosing_range_end [..] P#a().
#  ⌄ enclosing_range_start [..] P#r().
   attr_reader :r
#               ^ definition [..] P#r().
#               ⌃ enclosing_range_end [..] P#r().
#  ⌄ enclosing_range_start [..] P#`w=`().
   attr_writer :w
#               ^ definition [..] P#`w=`().
#               ⌃ enclosing_range_end [..] P#`w=`().
 
#  ⌄ enclosing_range_start [..] P#init().
   def init
#      ^^^^ definition [..] P#init().
     self.a = self.r
#         ^^^ reference [..] P#`a=`().
#                  ^ reference [..] P#r().
     self.w = self.a
#         ^^^ reference [..] P#`w=`().
#                  ^ reference [..] P#a().
   end
#    ⌃ enclosing_range_end [..] P#init().
 
#  ⌄ enclosing_range_start [..] P#wrong_init().
   def wrong_init
#      ^^^^^^^^^^ definition [..] P#wrong_init().
     # Check that 'r' is a method access but 'a' and 'w' are locals
     a = r
#    ^ definition local 1$1021288725
#        ^ reference [..] P#r().
     w = a
#    ^ definition local 2$1021288725
#    ^^^^^ reference local 2$1021288725
#        ^ reference local 1$1021288725
   end
#    ⌃ enclosing_range_end [..] P#wrong_init().
 end
#  ⌃ enclosing_range_end [..] P#
 
#⌄ enclosing_range_start [..] Object#useP().
 def useP
#    ^^^^ definition [..] Object#useP().
   p = P.new
#  ^ definition local 1$2121829932
#      ^ reference [..] P#
#        ^^^ reference [..] Class#new().
   p.a = p.r
#  ^ reference local 1$2121829932
#    ^^^ reference [..] P#`a=`().
#        ^ reference local 1$2121829932
#          ^ reference [..] P#r().
   p.w = p.a
#  ^ reference local 1$2121829932
#    ^^^ reference [..] P#`w=`().
#        ^ reference local 1$2121829932
#          ^ reference [..] P#a().
 end
#  ⌃ enclosing_range_end [..] Object#useP().
