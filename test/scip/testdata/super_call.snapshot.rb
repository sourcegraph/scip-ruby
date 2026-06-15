 # typed: true
 
 # Explicit-arg super (as opposed to implicit-arg, which is implicit_super_arg.rb)
 # Documents whether scip-ruby emits a reference to the parent method at `super`.
 
 class Parent
#      ^^^^^^ definition [..] Parent#
   def greet(name)
#      ^^^^^ definition [..] Parent#greet().
#            ^^^^ definition local 1$4213039946
     "Hi, " + name
#             ^^^^ reference local 1$4213039946
   end
 end
 
 class Child < Parent
#      ^^^^^ definition [..] Child#
#              ^^^^^^ reference [..] Parent#
   def greet(name)
#      ^^^^^ definition [..] Child#greet().
#            ^^^^ definition local 1$4213039946
     super(name)
#          ^^^^ reference local 1$4213039946
   end
 end
 
 class GrandChild < Child
#      ^^^^^^^^^^ definition [..] GrandChild#
#                   ^^^^^ reference [..] Child#
   def greet(name)
#      ^^^^^ definition [..] GrandChild#greet().
#            ^^^^ definition local 1$4213039946
     base = super("child of " + name)
#    ^^^^ definition local 2$4213039946
#                               ^^^^ reference local 1$4213039946
     base + "!"
#    ^^^^ reference local 2$4213039946
   end
 end
 
 def trigger
#    ^^^^^^^ definition [..] Object#trigger().
   _ = GrandChild.new.greet("x")
#  ^ definition local 2$1967206915
#      ^^^^^^^^^^ reference [..] GrandChild#
#                 ^^^ reference [..] Class#new().
#                     ^^^^^ reference [..] GrandChild#greet().
   return
 end
