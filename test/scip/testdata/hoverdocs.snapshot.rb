 # typed: true
 # options: showDocs
 
 # Class doc comment
 class C1
#      ^^ definition [..] C1#
#      documentation
#      | ```ruby
#      | class C1
#      | ```
#      documentation
#      | Class doc comment
   def m1
#  ^^^^^^ definition [..] C1#m1().
#  documentation
#  | ```ruby
#  | sig {returns(T.untyped)}
#  | def m1
#  | ```
   end
 
   sig { returns(T::Boolean) }
#  ^^^ reference [..] Sorbet#Private#Static#<Class:ResolvedSig>#sig().
#                ^ reference [..] T#
#                   ^^^^^^^ reference [..] T#Boolean.
#                   ^^^^^^^^^^ reference [..] Sorbet#Private#Static#ResolvedSig#
   def m2
#  ^^^^^^ definition [..] C1#m2().
#  documentation
#  | ```ruby
#  | sig {returns(T::Boolean)}
#  | def m2
#  | ```
     true
   end
 
   sig { params(C, T::Boolean).returns(T::Boolean) }
#  ^^^ reference [..] Sorbet#Private#Static#<Class:ResolvedSig>#sig().
#               ^ reference [..] T.untyped#
#                  ^ reference [..] T#
#                     ^^^^^^^ reference [..] T#Boolean.
#                                      ^ reference [..] T#
#                                         ^^^^^^^ reference [..] T#Boolean.
#                                         ^^^^^^^^^^ reference [..] Sorbet#Private#Static#ResolvedSig#
   def m3(c, b)
#  ^^^^^^^^^^^^ definition [..] C1#m3().
#  documentation
#  | ```ruby
#  | sig {params(c: T.untyped, b: T.untyped).returns(T::Boolean)}
#  | def m3(c, b)
#  | ```
#         ^ definition local 1~#2519626513
#         documentation
#         | ```ruby
#         | c = T.let(_, T.untyped)
#         | ```
#            ^ definition local 2~#2519626513
#            documentation
#            | ```ruby
#            | b = T.let(_, T.untyped)
#            | ```
     c.m2 || b
#    ^ reference local 1~#2519626513
#            ^ reference local 2~#2519626513
   end
 
   # _This_ is a
   # **doc comment.**
   def m4(xs)
#  ^^^^^^^^^^ definition [..] C1#m4().
#  documentation
#  | ```ruby
#  | sig {params(xs: T.untyped).returns(T.untyped)}
#  | def m4(xs)
#  | ```
#  documentation
#  | _This_ is a
#  | **doc comment.**
#         ^^ definition local 1~#2536404132
#         documentation
#         | ```ruby
#         | xs = T.let(_, T.untyped)
#         | ```
     xs[0]
#    ^^ reference local 1~#2536404132
   end
 
   # Yet another..
   # ...doc comment
   sig { returns(T::Boolean) }
#  ^^^ reference [..] Sorbet#Private#Static#<Class:ResolvedSig>#sig().
#                ^ reference [..] T#
#                   ^^^^^^^ reference [..] T#Boolean.
#                   ^^^^^^^^^^ reference [..] Sorbet#Private#Static#ResolvedSig#
   def m5
#  ^^^^^^ definition [..] C1#m5().
#  documentation
#  | ```ruby
#  | sig {returns(T::Boolean)}
#  | def m5
#  | ```
#  documentation
#  | Yet another..
#  | ...doc comment
     true
   end
 
   # And...
   # ...one more doc comment
   sig { params(C, T::Boolean).returns(T::Boolean) }
#  ^^^ reference [..] Sorbet#Private#Static#<Class:ResolvedSig>#sig().
#               ^ reference [..] T.untyped#
#                  ^ reference [..] T#
#                     ^^^^^^^ reference [..] T#Boolean.
#                                      ^ reference [..] T#
#                                         ^^^^^^^ reference [..] T#Boolean.
#                                         ^^^^^^^^^^ reference [..] Sorbet#Private#Static#ResolvedSig#
   def m6(c, b)
#  ^^^^^^^^^^^^ definition [..] C1#m6().
#  documentation
#  | ```ruby
#  | sig {params(c: T.untyped, b: T.untyped).returns(T::Boolean)}
#  | def m6(c, b)
#  | ```
#  documentation
#  | And...
#  | ...one more doc comment
#         ^ definition local 1~#2569959370
#         documentation
#         | ```ruby
#         | c = T.let(_, T.untyped)
#         | ```
#            ^ definition local 2~#2569959370
#            documentation
#            | ```ruby
#            | b = T.let(_, T.untyped)
#            | ```
     c.m2 || b
#    ^ reference local 1~#2569959370
#            ^ reference local 2~#2569959370
   end
 end
 
 class C2 # undocumented class
#      ^^ definition [..] C2#
#      documentation
#      | ```ruby
#      | class C2
#      | ```
 end
 
 # Module doc comment
 #
 # Some stuff
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
   class C3
#        ^^ definition [..] M1#C3#
#        documentation
#        | ```ruby
#        | class M1::C3
#        | ```
#        documentation
#        | This class is nested inside M1
   end
 
   # This module is nested inside M1
   module M2
#         ^^ definition [..] M1#M2#
#         documentation
#         | ```ruby
#         | module M1::M2
#         | ```
#         documentation
#         | This module is nested inside M1
     # This method is inside M1::M2
     sig { returns(T::Boolean) }
#    ^^^ reference [..] Sorbet#Private#Static#<Class:ResolvedSig>#sig().
#                  ^ reference [..] T#
#                     ^^^^^^^ reference [..] T#Boolean.
#                     ^^^^^^^^^^ reference [..] Sorbet#Private#Static#ResolvedSig#
     def n1
#    ^^^^^^ definition [..] M1#M2#n1().
#    documentation
#    | ```ruby
#    | sig {returns(T::Boolean)}
#    | def n1
#    | ```
#    documentation
#    | This method is inside M1::M2
       true
     end
 
     # This method is also inside M1::M2
     def n2
#    ^^^^^^ definition [..] M1#M2#n2().
#    documentation
#    | ```ruby
#    | sig {returns(T.untyped)}
#    | def n2
#    | ```
#    documentation
#    | This method is also inside M1::M2
     end
   end
 end
 
 # This is a global function
 def f1
#^^^^^^ definition [..] Object#f1().
#documentation
#| ```ruby
#| sig {returns(T.untyped)}
#| def f1
#| ```
#documentation
#| This is a global function
   M1::M2::m6
#  ^^ reference [..] M1#
#      ^^ reference [..] M1#M2#
   M1::M2::m7
#  ^^ reference [..] M1#
#      ^^ reference [..] M1#M2#
 end
 
 # Yet another global function
 sig { returns(T::Integer) }
#^^^ reference [..] Sorbet#Private#Static#<Class:ResolvedSig>#sig().
#              ^ reference [..] T#
#                 ^^^^^^^ reference [..] T.untyped#
#                 ^^^^^^^^^^ reference [..] Sorbet#Private#Static#ResolvedSig#
 def f2
#^^^^^^ definition [..] Object#f2().
#documentation
#| ```ruby
#| sig {returns(T::Integer (unresolved))}
#| def f2
#| ```
#documentation
#| Yet another global function
   return 10
 end
 
 def f3 # undocumented global function
#^^^^^^ definition [..] Object#f3().
#documentation
#| ```ruby
#| sig {returns(T.untyped)}
#| def f3
#| ```
 end
 
 sig { returns(T::Integer) }
#^^^ reference [..] Sorbet#Private#Static#<Class:ResolvedSig>#sig().
#              ^ reference [..] T#
#                 ^^^^^^^ reference [..] T.untyped#
#                 ^^^^^^^^^^ reference [..] Sorbet#Private#Static#ResolvedSig#
 def f4 # another undocumented global function
#^^^^^^ definition [..] Object#f4().
#documentation
#| ```ruby
#| sig {returns(T::Integer (unresolved))}
#| def f4
#| ```
   return 10
 end
 
 # Parent class
 class K1
#      ^^ definition [..] K1#
#      documentation
#      | ```ruby
#      | class K1
#      | ```
#      documentation
#      | Parent class
   # sets @x and @@y
   def p1
#  ^^^^^^ definition [..] K1#p1().
#  documentation
#  | ```ruby
#  | sig {returns(T.untyped)}
#  | def p1
#  | ```
#  documentation
#  | sets @x and @@y
     @x = 10
#    ^^ definition [..] K1#@x.
#    documentation
#    | ```ruby
#    | @x = T.let(_, T.untyped)
#    | ```
     @@y = 10
#    ^^^ definition [..] K1#@@y.
#    documentation
#    | ```ruby
#    | @@y = T.let(_, T.untyped)
#    | ```
#    ^^^^^^^^ reference [..] K1#@@y.
   end
 
   # lorem ipsum, you get it
   def self.p2
#  ^^^^^^^^^^^ definition [..] <Class:K1>#p2().
#  documentation
#  | ```ruby
#  | sig {returns(T.untyped)}
#  | def self.p2
#  | ```
#  documentation
#  | lorem ipsum, you get it
     @z = 10
#    ^^ definition [..] <Class:K1>#@z.
#    documentation
#    | ```ruby
#    | @z = T.let(_, T.untyped)
#    | ```
#    ^^^^^^^ reference [..] <Class:K1>#@z.
   end
 end
 
 # Subclass
 class K2 < K1
#      ^^ definition [..] K2#
#      documentation
#      | ```ruby
#      | class K2 < K1
#      | ```
#      documentation
#      | Subclass
#           ^^ definition [..] K1#
#           documentation
#           | ```ruby
#           | class K1
#           | ```
#           documentation
#           | Parent class
   # doc comment on class var ooh
   @z = 9
#  ^^ definition [..] <Class:K2>#@z.
#  documentation
#  | ```ruby
#  | @z = T.let(_, T.untyped)
#  | ```
#  documentation
#  | doc comment on class var ooh
 
   # overrides K1's p1
   def p1
#  ^^^^^^ definition [..] K2#p1().
#  documentation
#  | ```ruby
#  | sig {returns(T.untyped)}
#  | def p1
#  | ```
#  documentation
#  | overrides K1's p1
     @x = 20
#    ^^ definition [..] K2#@x.
#    documentation
#    | ```ruby
#    | @x = T.let(_, T.untyped)
#    | ```
     @@y = 20
#    ^^^ definition [..] K2#@@y.
#    documentation
#    | ```ruby
#    | @@y = T.let(_, T.untyped)
#    | ```
     @z += @x
#    ^^ reference [..] K2#@z.
#    ^^ reference (write) [..] K2#@z.
#    ^^^^^^^^ reference [..] K2#@z.
#          ^^ reference [..] K2#@x.
   end
 end
