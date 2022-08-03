 # typed: true
 # options: showDocs
 
 def assign_different_branches(b)
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] Object#assign_different_branches().
#documentation
#| ```ruby
#| sig {params(b: T.untyped).returns(T.untyped)}
#| def assign_different_branches(b)
#| ```
#                              ^ definition local 1~#3317016627
#                              documentation
#                              | ```ruby
#                              | b = T.let(_, T.untyped)
#                              | ```
   if b
     x = 1
#    ^ definition local 2~#3317016627
#    documentation
#    | ```ruby
#    | x = T.let(_, Integer(1))
#    | ```
   else
     x = nil
#    ^ definition local 2~#3317016627
#    documentation
#    | ```ruby
#    | x = T.let(_, Integer(1))
#    | ```
   end
   return
 end
 
 def change_different_branches(b)
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] Object#change_different_branches().
#documentation
#| ```ruby
#| sig {params(b: T.untyped).returns(T.untyped)}
#| def change_different_branches(b)
#| ```
#                              ^ definition local 1~#2122680152
#                              documentation
#                              | ```ruby
#                              | b = T.let(_, T.untyped)
#                              | ```
   x = 'foo'
#  ^ definition local 2~#2122680152
#  documentation
#  | ```ruby
#  | x = T.let(_, String("foo"))
#  | ```
   if b
     x = 1
#    ^ reference (write) local 2~#2122680152
#    override_documentation
#    | ```ruby
#    | x = T.let(_, Integer(1))
#    | ```
   else
     x = nil
#    ^ reference (write) local 2~#2122680152
#    override_documentation
#    | ```ruby
#    | x = T.let(_, NilClass)
#    | ```
   end
   return
 end
 
 def loop_type_change(bs)
#^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] Object#loop_type_change().
#documentation
#| ```ruby
#| sig {params(bs: T.untyped).returns(T.untyped)}
#| def loop_type_change(bs)
#| ```
#                     ^^ definition local 1~#4057334513
#                     documentation
#                     | ```ruby
#                     | bs = T.let(_, T.untyped)
#                     | ```
   x = nil
#  ^ definition local 2~#4057334513
#  documentation
#  | ```ruby
#  | x = T.let(_, NilClass)
#  | ```
   for b in bs
#      ^ definition local 3~#4057334513
#      documentation
#      | ```ruby
#      | b = T.let(_, T.untyped)
#      | ```
#           ^^ reference local 1~#4057334513
     puts x
#         ^ reference local 2~#4057334513
     if b
       x = 1
#      ^ reference (write) local 2~#4057334513
#      override_documentation
#      | ```ruby
#      | x = T.let(_, T.untyped)
#      | ```
#      ^^^^^ reference local 2~#4057334513
#      override_documentation
#      | ```ruby
#      | x = 1 = T.let(_, T.untyped)
#      | ```
     else
       x = 's'
#      ^ reference (write) local 2~#4057334513
#      override_documentation
#      | ```ruby
#      | x = T.let(_, T.untyped)
#      | ```
#      ^^^^^^^ reference local 2~#4057334513
#      override_documentation
#      | ```ruby
#      | x = 's' = T.let(_, T.untyped)
#      | ```
     end
   end
   return
 end
 
 class C
#      ^ definition [..] C#
#      documentation
#      | ```ruby
#      | class C
#      | ```
   @k = nil
#  ^^ definition [..] <Class:C>#@k.
#  documentation
#  | ```ruby
#  | @k = T.let(_, T.untyped)
#  | ```
 
   def change_type(b)
#  ^^^^^^^^^^^^^^^^^^ definition [..] C#change_type().
#  documentation
#  | ```ruby
#  | sig {params(b: T.untyped).returns(T.untyped)}
#  | def change_type(b)
#  | ```
#                  ^ definition local 1~#2066187318
#                  documentation
#                  | ```ruby
#                  | b = T.let(_, T.untyped)
#                  | ```
     @f = nil
#    ^^ definition [..] C#@f.
#    documentation
#    | ```ruby
#    | @f = T.let(_, T.untyped)
#    | ```
     @@g = nil
#    ^^^ definition [..] C#@@g.
#    documentation
#    | ```ruby
#    | @@g = T.let(_, T.untyped)
#    | ```
     @k = nil
#    ^^ definition [..] C#@k.
#    documentation
#    | ```ruby
#    | @k = T.let(_, T.untyped)
#    | ```
     if b
       @f = 1
#      ^^ reference (write) [..] C#@f.
#      override_documentation
#      | ```ruby
#      | @f = T.let(_, Integer(1))
#      | ```
       @@g = 1
#      ^^^ reference (write) [..] C#@@g.
#      override_documentation
#      | ```ruby
#      | @@g = T.let(_, Integer(1))
#      | ```
       @k = 1
#      ^^ reference (write) [..] C#@k.
#      override_documentation
#      | ```ruby
#      | @k = T.let(_, Integer(1))
#      | ```
#      ^^^^^^ reference [..] C#@k.
#      override_documentation
#      | ```ruby
#      | @k = T.let(_, Integer(1))
#      | ```
     else
       @f = 'f'
#      ^^ reference (write) [..] C#@f.
#      override_documentation
#      | ```ruby
#      | @f = T.let(_, String("f"))
#      | ```
       @@g = 'g'
#      ^^^ reference (write) [..] C#@@g.
#      override_documentation
#      | ```ruby
#      | @@g = T.let(_, String("g"))
#      | ```
       @k = 'k'
#      ^^ reference (write) [..] C#@k.
#      override_documentation
#      | ```ruby
#      | @k = T.let(_, String("k"))
#      | ```
#      ^^^^^^^^ reference [..] C#@k.
#      override_documentation
#      | ```ruby
#      | @k = T.let(_, String("k"))
#      | ```
     end
   end
 end
 
 class D < C
#      ^ definition [..] D#
#      documentation
#      | ```ruby
#      | class D < C
#      | ```
#          ^ definition [..] C#
#          documentation
#          | ```ruby
#          | class C
#          | ```
   def change_type(b)
#  ^^^^^^^^^^^^^^^^^^ definition [..] D#change_type().
#  documentation
#  | ```ruby
#  | sig {params(b: T.untyped).returns(T.untyped)}
#  | def change_type(b)
#  | ```
#                  ^ definition local 1~#2066187318
#                  documentation
#                  | ```ruby
#                  | b = T.let(_, T.untyped)
#                  | ```
     if !b
#        ^ reference local 1~#2066187318
       @f = 1
#      ^^ definition [..] D#@f.
#      documentation
#      | ```ruby
#      | @f = T.let(_, T.untyped)
#      | ```
       @@g = 1
#      ^^^ definition [..] D#@@g.
#      documentation
#      | ```ruby
#      | @@g = T.let(_, T.untyped)
#      | ```
       @k = 1
#      ^^ definition [..] D#@k.
#      documentation
#      | ```ruby
#      | @k = T.let(_, T.untyped)
#      | ```
#      ^^^^^^ reference [..] D#@k.
#      override_documentation
#      | ```ruby
#      | @k = T.let(_, Integer(1))
#      | ```
     else
       @f = 'f'
#      ^^ definition [..] D#@f.
#      documentation
#      | ```ruby
#      | @f = T.let(_, T.untyped)
#      | ```
       @@g = 'g'
#      ^^^ definition [..] D#@@g.
#      documentation
#      | ```ruby
#      | @@g = T.let(_, T.untyped)
#      | ```
       @k = 'k'
#      ^^ definition [..] D#@k.
#      documentation
#      | ```ruby
#      | @k = T.let(_, T.untyped)
#      | ```
#      ^^^^^^^^ reference [..] D#@k.
#      override_documentation
#      | ```ruby
#      | @k = T.let(_, String("k"))
#      | ```
     end
   end
 end
