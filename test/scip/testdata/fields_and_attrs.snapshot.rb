 # typed: true
 
 # Useful SO discussion with examples for class variables and instance variables,
 # and how they interact with inheritance: https://stackoverflow.com/a/15773671/2682729
 
 class K
#      ^ definition scip-ruby gem TODO TODO K#
   def m1
#  ^^^^^^ definition scip-ruby gem TODO TODO K#m1().
     @f = 0
#    ^^ definition scip-ruby gem TODO TODO K#@f.
     @g = @f
#    ^^ definition scip-ruby gem TODO TODO K#@g.
#         ^^ reference scip-ruby gem TODO TODO K#@f.
     return
   end
   def m2
#  ^^^^^^ definition scip-ruby gem TODO TODO K#m2().
     @f = @g
#    ^^ definition scip-ruby gem TODO TODO K#@f.
#         ^^ reference scip-ruby gem TODO TODO K#@g.
     return
   end
 end
 
 # Extended
 class K
#      ^ definition scip-ruby gem TODO TODO K#
   def m3
#  ^^^^^^ definition scip-ruby gem TODO TODO K#m3().
     @g = @f
#    ^^ definition scip-ruby gem TODO TODO K#@g.
#         ^^ reference scip-ruby gem TODO TODO K#@f.
     return
   end
 end
 
 # Class instance var
 class L
#      ^ definition scip-ruby gem TODO TODO L#
   @x = 10
#  ^^ definition scip-ruby gem TODO TODO <Class:L>#@x.
   @y = 9
#  ^^ definition scip-ruby gem TODO TODO <Class:L>#@y.
   def self.m1
#  ^^^^^^^^^^^ definition scip-ruby gem TODO TODO <Class:L>#m1().
     @y = @x
#    ^^ definition scip-ruby gem TODO TODO <Class:L>#@y.
#         ^^ reference scip-ruby gem TODO TODO <Class:L>#@x.
     return
   end
 
   def m2
#  ^^^^^^ definition scip-ruby gem TODO TODO L#m2().
     # FIXME: Missing references
     self.class.y = self.class.x
     return
   end
 end
 
 # Class var
 class N
#      ^ definition scip-ruby gem TODO TODO N#
   @@a = 0
#  ^^^ definition scip-ruby gem TODO TODO <Class:N>#@@a.
   @@b = 1
#  ^^^ definition scip-ruby gem TODO TODO <Class:N>#@@b.
   def self.m1
#  ^^^^^^^^^^^ definition scip-ruby gem TODO TODO <Class:N>#m1().
     @@b = @@a
#    ^^^ definition scip-ruby gem TODO TODO <Class:N>#@@b.
#          ^^^ reference scip-ruby gem TODO TODO <Class:N>#@@a.
     return
   end
 
   def m2
#  ^^^^^^ definition scip-ruby gem TODO TODO N#m2().
     @@b = @@a
#    ^^^ definition scip-ruby gem TODO TODO N#@@b.
#          ^^^ reference scip-ruby gem TODO TODO N#@@a.
     return
   end
 
   def m3
#  ^^^^^^ definition scip-ruby gem TODO TODO N#m3().
     # FIXME: Missing references
     self.class.b = self.class.a
   end
 end
 
 # Accessors
 class P
#      ^ definition scip-ruby gem TODO TODO P#
   attr_accessor :a
#  ^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO P#a=().
#  ^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO P#a().
   attr_reader :r
#  ^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO P#r().
   attr_writer :w
#  ^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO P#w=().
 
   def init
#  ^^^^^^^^ definition scip-ruby gem TODO TODO P#init().
     self.a = self.r
#         ^^^ reference scip-ruby gem TODO TODO P#a=().
#                  ^ reference scip-ruby gem TODO TODO P#r().
     self.w = self.a
#         ^^^ reference scip-ruby gem TODO TODO P#w=().
#                  ^ reference scip-ruby gem TODO TODO P#a().
   end
 
   def wrong_init
#  ^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO P#wrong_init().
     # Check that 'r' is a method access but 'a' and 'w' are locals
     a = r
#    ^ definition local 1~#1021288725
#        ^ reference scip-ruby gem TODO TODO P#r().
     w = a
#    ^ definition local 2~#1021288725
#    ^^^^^ reference local 2~#1021288725
#        ^ reference local 1~#1021288725
   end
 end
 
 def useP
#^^^^^^^^ definition scip-ruby gem TODO TODO Object#useP().
   p = P.new
#  ^ definition local 1~#2121829932
#      ^ reference scip-ruby gem TODO TODO P#
   p.a = p.r
#  ^ reference local 1~#2121829932
#    ^^^ reference scip-ruby gem TODO TODO P#a=().
#        ^ reference local 1~#2121829932
#          ^ reference scip-ruby gem TODO TODO P#r().
   p.w = p.a
#  ^ reference local 1~#2121829932
#    ^^^ reference scip-ruby gem TODO TODO P#w=().
#        ^ reference local 1~#2121829932
#          ^ reference scip-ruby gem TODO TODO P#a().
 end
