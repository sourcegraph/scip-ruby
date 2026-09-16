 # typed: true
 
 # Explicit-arg super (as opposed to implicit-arg, which is implicit_super_arg.rb)
 # Documents whether scip-ruby emits a reference to the parent method at `super`.
 
#⌄ enclosing_range_start [..] Parent#
 class Parent
#      ^^^^^^ definition [..] Parent#
#  ⌄ enclosing_range_start [..] Parent#greet().
   def greet(name)
#      ^^^^^ definition [..] Parent#greet().
#            ^^^^ definition local 1$3728988031
     "Hi, " + name
#           ^ reference [..] String#+().
#             ^^^^ reference local 1$3728988031
   end
#    ⌃ enclosing_range_end [..] Parent#greet().
 end
#  ⌃ enclosing_range_end [..] Parent#
 
#⌄ enclosing_range_start [..] Child#
 class Child < Parent
#      ^^^^^ definition [..] Child#
#              ^^^^^^ reference [..] Parent#
#  ⌄ enclosing_range_start [..] Child#greet().
   def greet(name)
#      ^^^^^ definition [..] Child#greet().
#            ^^^^ definition local 1$1120953439
     super(name)
#          ^^^^ reference local 1$1120953439
   end
#    ⌃ enclosing_range_end [..] Child#greet().
 end
#  ⌃ enclosing_range_end [..] Child#
 
#⌄ enclosing_range_start [..] GrandChild#
 class GrandChild < Child
#      ^^^^^^^^^^ definition [..] GrandChild#
#                   ^^^^^ reference [..] Child#
#  ⌄ enclosing_range_start [..] GrandChild#greet().
   def greet(name)
#      ^^^^^ definition [..] GrandChild#greet().
#            ^^^^ definition local 1$2273071383
     base = super("child of " + name)
#    ^^^^ definition local 2$2273071383
#                             ^ reference [..] String#+().
#                               ^^^^ reference local 1$2273071383
     base + "!"
#    ^^^^ reference local 2$2273071383
   end
#    ⌃ enclosing_range_end [..] GrandChild#greet().
 end
#  ⌃ enclosing_range_end [..] GrandChild#
 
#⌄ enclosing_range_start [..] Object#trigger().
 def trigger
#    ^^^^^^^ definition [..] Object#trigger().
   _ = GrandChild.new.greet("x")
#  ^ definition local 2$326825877
#      ^^^^^^^^^^ reference [..] GrandChild#
#                 ^^^ reference [..] Class#new().
#                     ^^^^^ reference [..] GrandChild#greet().
   return
 end
#  ⌃ enclosing_range_end [..] Object#trigger().
