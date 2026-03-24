 # typed: true
 # options: showDocs
 
 # Class doc comment
#⌄ enclosing_range_start [..] C1#
 class C1
#      ^^ definition [..] C1#
#      documentation
#      | ```ruby
#      | class C1
#      | ```
#      documentation
#      | Class doc comment
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
#  ⌄ enclosing_range_start [..] C1#m1().
   def m1
#      ^^ definition [..] C1#m1().
#      documentation
#      | ```ruby
#      | sig { returns(T.untyped) }
#      | def m1
#      | ```
   end
#    ⌃ enclosing_range_end [..] C1#m1().
 
   sig { returns(T::Boolean) }
#                   ^^^^^^^ reference [..] T#Boolean.
#  ⌄ enclosing_range_start [..] C1#m2().
   def m2
#      ^^ definition [..] C1#m2().
#      documentation
#      | ```ruby
#      | sig { returns(T::Boolean) }
#      | def m2
#      | ```
     true
   end
#    ⌃ enclosing_range_end [..] C1#m2().
 
   sig { params(C, T::Boolean).returns(T::Boolean) }
#                     ^^^^^^^ reference [..] T#Boolean.
#                                         ^^^^^^^ reference [..] T#Boolean.
#  ⌄ enclosing_range_start [..] C1#m3().
   def m3(c, b)
#      ^^ definition [..] C1#m3().
#      documentation
#      | ```ruby
#      | sig { params(c: T.untyped, b: T.untyped).returns(T::Boolean) }
#      | def m3(c, b)
#      | ```
#         ^ definition local 1$2519626513
#         documentation
#         | ```ruby
#         | c (T.untyped)
#         | ```
#            ^ definition local 2$2519626513
#            documentation
#            | ```ruby
#            | b (T.untyped)
#            | ```
     c.m2 || b
#    ^ reference local 1$2519626513
#            ^ reference local 2$2519626513
   end
#    ⌃ enclosing_range_end [..] C1#m3().
 
   # _This_ is a
   # **doc comment.**
#  ⌄ enclosing_range_start [..] C1#m4().
   def m4(xs)
#      ^^ definition [..] C1#m4().
#      documentation
#      | ```ruby
#      | sig { params(xs: T.untyped).returns(T.untyped) }
#      | def m4(xs)
#      | ```
#      documentation
#      | _This_ is a
#      | **doc comment.**
#         ^^ definition local 1$2536404132
#         documentation
#         | ```ruby
#         | xs (T.untyped)
#         | ```
     xs[0]
#    ^^ reference local 1$2536404132
   end
#    ⌃ enclosing_range_end [..] C1#m4().
 
   # Yet another..
   # ...doc comment
   sig { returns(T::Boolean) }
#                   ^^^^^^^ reference [..] T#Boolean.
#  ⌄ enclosing_range_start [..] C1#m5().
   def m5
#      ^^ definition [..] C1#m5().
#      documentation
#      | ```ruby
#      | sig { returns(T::Boolean) }
#      | def m5
#      | ```
#      documentation
#      | Yet another..
#      | ...doc comment
     true
   end
#    ⌃ enclosing_range_end [..] C1#m5().
 
   # And...
   # ...one more doc comment
   sig { params(C, T::Boolean).returns(T::Boolean) }
#                     ^^^^^^^ reference [..] T#Boolean.
#                                         ^^^^^^^ reference [..] T#Boolean.
#  ⌄ enclosing_range_start [..] C1#m6().
   def m6(c, b)
#      ^^ definition [..] C1#m6().
#      documentation
#      | ```ruby
#      | sig { params(c: T.untyped, b: T.untyped).returns(T::Boolean) }
#      | def m6(c, b)
#      | ```
#      documentation
#      | And...
#      | ...one more doc comment
#         ^ definition local 1$2569959370
#         documentation
#         | ```ruby
#         | c (T.untyped)
#         | ```
#            ^ definition local 2$2569959370
#            documentation
#            | ```ruby
#            | b (T.untyped)
#            | ```
     c.m2 || b
#    ^ reference local 1$2569959370
#            ^ reference local 2$2569959370
   end
#    ⌃ enclosing_range_end [..] C1#m6().
 end
#  ⌃ enclosing_range_end [..] C1#
 
#⌄ enclosing_range_start [..] C2#
 class C2 # undocumented class
#      ^^ definition [..] C2#
#      documentation
#      | ```ruby
#      | class C2
#      | ```
 end
#  ⌃ enclosing_range_end [..] C2#
 
 # Module doc comment
 #
 # Some stuff
#⌄ enclosing_range_start [..] M1#
 module M1
#       ^^ definition [..] M1#
#       documentation
#       | ```ruby
#       | module M1
#       | ```
#       documentation
#       | Module doc comment
#       | 
#       | Some stuff
   # This class is nested inside M1
#  ⌄ enclosing_range_start [..] M1#C3#
   class C3
#        ^^ definition [..] M1#C3#
#        documentation
#        | ```ruby
#        | class M1::C3
#        | ```
#        documentation
#        | This class is nested inside M1
   end
#    ⌃ enclosing_range_end [..] M1#C3#
 
   # This module is nested inside M1
#  ⌄ enclosing_range_start [..] M1#M2#
   module M2
#         ^^ definition [..] M1#M2#
#         documentation
#         | ```ruby
#         | module M1::M2
#         | ```
#         documentation
#         | This module is nested inside M1
     extend T::Sig
#    ^^^^^^ reference [..] Kernel#extend().
 
     # This method is inside M1::M2
     sig { returns(T::Boolean) }
#                     ^^^^^^^ reference [..] T#Boolean.
#    ⌄ enclosing_range_start [..] M1#M2#n1().
     def n1
#        ^^ definition [..] M1#M2#n1().
#        documentation
#        | ```ruby
#        | sig { returns(T::Boolean) }
#        | def n1
#        | ```
#        documentation
#        | This method is inside M1::M2
       true
     end
#      ⌃ enclosing_range_end [..] M1#M2#n1().
 
     # This method is also inside M1::M2
#    ⌄ enclosing_range_start [..] M1#M2#n2().
     def n2
#        ^^ definition [..] M1#M2#n2().
#        documentation
#        | ```ruby
#        | sig { returns(T.untyped) }
#        | def n2
#        | ```
#        documentation
#        | This method is also inside M1::M2
     end
#      ⌃ enclosing_range_end [..] M1#M2#n2().
   end
#    ⌃ enclosing_range_end [..] M1#M2#
 end
#  ⌃ enclosing_range_end [..] M1#
 
 # This is a global function
#⌄ enclosing_range_start [..] Object#f1().
 def f1
#    ^^ definition [..] Object#f1().
#    documentation
#    | ```ruby
#    | sig { returns(T.untyped) }
#    | def f1
#    | ```
#    documentation
#    | This is a global function
   M1::M2::m6
#  ^^ reference [..] M1#
#      ^^ reference [..] M1#M2#
   M1::M2::m7
#  ^^ reference [..] M1#
#      ^^ reference [..] M1#M2#
 end
#  ⌃ enclosing_range_end [..] Object#f1().
 
 # Yet another global function
 sig { returns(T::Integer) }
#^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#      ^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#              ^ reference [..] T#
#⌄ enclosing_range_start [..] Object#f2().
 def f2
#    ^^ definition [..] Object#f2().
#    documentation
#    | ```ruby
#    | sig { returns(T::Integer (unresolved)) }
#    | def f2
#    | ```
#    documentation
#    | Yet another global function
   return 10
 end
#  ⌃ enclosing_range_end [..] Object#f2().
 
#⌄ enclosing_range_start [..] Object#f3().
 def f3 # undocumented global function
#    ^^ definition [..] Object#f3().
#    documentation
#    | ```ruby
#    | sig { returns(T.untyped) }
#    | def f3
#    | ```
 end
#  ⌃ enclosing_range_end [..] Object#f3().
 
 extend T::Sig
#^^^^^^ reference [..] Kernel#extend().
#       ^ reference [..] T#
#          ^^^ reference [..] T#Sig#
 
 sig { returns(T::Integer) }
#^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#      ^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#              ^ reference [..] T#
#⌄ enclosing_range_start [..] Object#f4().
 def f4 # another undocumented global function
#    ^^ definition [..] Object#f4().
#    documentation
#    | ```ruby
#    | sig { returns(T::Integer (unresolved)) }
#    | def f4
#    | ```
   return 10
 end
#  ⌃ enclosing_range_end [..] Object#f4().
 
 # Parent class
#⌄ enclosing_range_start [..] K1#
 class K1
#      ^^ definition [..] K1#
#      documentation
#      | ```ruby
#      | class K1
#      | ```
#      documentation
#      | Parent class
   # sets @x and @@y
#  ⌄ enclosing_range_start [..] K1#p1().
   def p1
#      ^^ definition [..] K1#p1().
#      documentation
#      | ```ruby
#      | sig { returns(T.untyped) }
#      | def p1
#      | ```
#      documentation
#      | sets @x and @@y
     @x = 10
#    ^^ definition [..] K1#`@x`.
#    documentation
#    | ```ruby
#    | @x (T.untyped)
#    | ```
     @@y = 10
#    ^^^ definition [..] `<Class:K1>`#`@@y`.
#    ^^^^^^^^ reference [..] `<Class:K1>`#`@@y`.
#    override_documentation
#    | ```ruby
#    | @@y (Integer(10))
#    | ```
   end
#    ⌃ enclosing_range_end [..] K1#p1().
 
   # lorem ipsum, you get it
#  ⌄ enclosing_range_start [..] `<Class:K1>`#p2().
   def self.p2
#           ^^ definition [..] `<Class:K1>`#p2().
#           documentation
#           | ```ruby
#           | sig { returns(T.untyped) }
#           | def self.p2
#           | ```
#           documentation
#           | lorem ipsum, you get it
     @z = 10
#    ^^ definition [..] `<Class:K1>`#`@z`.
#    ^^^^^^^ reference [..] `<Class:K1>`#`@z`.
#    override_documentation
#    | ```ruby
#    | @z (Integer(10))
#    | ```
   end
#    ⌃ enclosing_range_end [..] `<Class:K1>`#p2().
 end
#  ⌃ enclosing_range_end [..] K1#
 
 # Subclass
#⌄ enclosing_range_start [..] K2#
 class K2 < K1
#      ^^ definition [..] K2#
#      documentation
#      | ```ruby
#      | class K2 < K1
#      | ```
#      documentation
#      | Subclass
#           ^^ reference [..] K1#
   # doc comment on class var ooh
   @z = 9
#  ^^ definition [..] `<Class:K2>`#`@z`.
#  documentation
#  | ```ruby
#  | @z (T.untyped)
#  | ```
#  documentation
#  | doc comment on class var ooh
 
   # overrides K1's p1
#  ⌄ enclosing_range_start [..] K2#p1().
   def p1
#      ^^ definition [..] K2#p1().
#      documentation
#      | ```ruby
#      | sig { returns(T.untyped) }
#      | def p1
#      | ```
#      documentation
#      | overrides K1's p1
     @x = 20
#    ^^ definition [..] K2#`@x`.
#    relation definition=[..] K1#`@x`.
     @@y = 20
#    ^^^ definition [..] `<Class:K2>`#`@@y`.
#    documentation
#    | ```ruby
#    | @@y (T.untyped)
#    | ```
#    relation definition=[..] `<Class:K1>`#`@@y`.
     @z += @x
#    ^^ reference (write) [..] K2#`@z`.
#    ^^ reference [..] K2#`@z`.
#    ^^^^^^^^ reference [..] K2#`@z`.
#          ^^ reference [..] K2#`@x`.
#          override_documentation
#          | ```ruby
#          | @x (Integer(20))
#          | ```
#          relation definition=[..] K1#`@x`.
   end
#    ⌃ enclosing_range_end [..] K2#p1().
 end
#  ⌃ enclosing_range_end [..] K2#
