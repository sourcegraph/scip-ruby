 # typed: true
 
 # Useful SO discussion with examples for class variables and instance variables,
 # and how they interact with inheritance: https://stackoverflow.com/a/15773671/2682729
 
 class K
#      ^ definition [..] K#
   def m1
#  ^^^^^^ definition [..] K#m1().
     @f = 0
#    ^^ definition [..] K#`@f`.
     @g = @f
#    ^^ definition [..] K#`@g`.
#         ^^ reference [..] K#`@f`.
     return
   end
   def m2
#  ^^^^^^ definition [..] K#m2().
     @f = @g
#    ^^ definition [..] K#`@f`.
#         ^^ reference [..] K#`@g`.
     return
   end
 end
 
 # Extended
 class K
#      ^ definition [..] K#
   def m3
#  ^^^^^^ definition [..] K#m3().
     @g = @f
#    ^^ definition [..] K#`@g`.
#         ^^ reference [..] K#`@f`.
     return
   end
 end
 
 # Class instance var
 class L
#      ^ definition [..] L#
   @x = 10
#  ^^ definition [..] `<Class:L>`#`@x`.
   @y = 9
#  ^^ definition [..] `<Class:L>`#`@y`.
   def self.m1
#  ^^^^^^^^^^^ definition [..] `<Class:L>`#m1().
     @y = @x
#    ^^ definition [..] `<Class:L>`#`@y`.
#         ^^ reference [..] `<Class:L>`#`@x`.
     return
   end
 
   def m2
#  ^^^^^^ definition [..] L#m2().
     # FIXME: Missing references
     self.class.y = self.class.x
     return
   end
 end
 
 # Class var
 class N
#      ^ definition [..] N#
   @@a = 0
#  ^^^ definition [..] `<Class:N>`#`@@a`.
   @@b = 1
#  ^^^ definition [..] `<Class:N>`#`@@b`.
   def self.m1
#  ^^^^^^^^^^^ definition [..] `<Class:N>`#m1().
     @@b = @@a
#    ^^^ definition [..] `<Class:N>`#`@@b`.
#          ^^^ reference [..] `<Class:N>`#`@@a`.
     return
   end
 
   def m2
#  ^^^^^^ definition [..] N#m2().
     @@b = @@a
#    ^^^ definition [..] N#`@@b`.
#          ^^^ reference [..] N#`@@a`.
     return
   end
 
   def m3
#  ^^^^^^ definition [..] N#m3().
     # FIXME: Missing references
     self.class.b = self.class.a
   end
 end
 
 # Accessors
 class P
#      ^ definition [..] P#
   attr_accessor :a
#  ^^^^^^^^^^^^^^^^ definition [..] P#`a=`().
#  ^^^^^^^^^^^^^^^^ definition [..] P#a().
   attr_reader :r
#  ^^^^^^^^^^^^^^ definition [..] P#r().
   attr_writer :w
#  ^^^^^^^^^^^^^^ definition [..] P#`w=`().
 
   def init
#  ^^^^^^^^ definition [..] P#init().
     self.a = self.r
#         ^^^ reference [..] P#`a=`().
#                  ^ reference [..] P#r().
     self.w = self.a
#         ^^^ reference [..] P#`w=`().
#                  ^ reference [..] P#a().
   end
 
   def wrong_init
#  ^^^^^^^^^^^^^^ definition [..] P#wrong_init().
     # Check that 'r' is a method access but 'a' and 'w' are locals
     a = r
#    ^ definition local 1~#1021288725
#        ^ reference [..] P#r().
     w = a
#    ^ definition local 2~#1021288725
#    ^^^^^ reference local 2~#1021288725
#        ^ reference local 1~#1021288725
   end
 end
 
 def useP
#^^^^^^^^ definition [..] Object#useP().
   p = P.new
#  ^ definition local 1~#2121829932
#      ^ reference [..] P#
   p.a = p.r
#  ^ reference local 1~#2121829932
#    ^^^ reference [..] P#`a=`().
#        ^ reference local 1~#2121829932
#          ^ reference [..] P#r().
   p.w = p.a
#  ^ reference local 1~#2121829932
#    ^^^ reference [..] P#`w=`().
#        ^ reference local 1~#2121829932
#          ^ reference [..] P#a().
 end
