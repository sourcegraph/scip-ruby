 # typed: true
 # options: showDocs
 
 def assign_different_branches(b)
#    ^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] Object#assign_different_branches().
#    documentation
#    | ```ruby
#    | sig {params(b: T.untyped).returns(T.untyped)}
#    | def assign_different_branches(b)
#    | ```
#                              ^ definition local 1~#3317016627
#                              documentation
#                              | ```ruby
#                              | b (T.untyped)
#                              | ```
   if b
     x = 1
#    ^ definition local 2~#3317016627
#    documentation
#    | ```ruby
#    | x (Integer(1))
#    | ```
   else
     x = nil
#    ^ definition local 2~#3317016627
#    documentation
#    | ```ruby
#    | x (Integer(1))
#    | ```
   end
   return
 end
 
 def change_different_branches(b)
#    ^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] Object#change_different_branches().
#    documentation
#    | ```ruby
#    | sig {params(b: T.untyped).returns(T.untyped)}
#    | def change_different_branches(b)
#    | ```
#                              ^ definition local 1~#2122680152
#                              documentation
#                              | ```ruby
#                              | b (T.untyped)
#                              | ```
   x = 'foo'
#  ^ definition local 2~#2122680152
#  documentation
#  | ```ruby
#  | x (String("foo"))
#  | ```
   if b
     x = 1
#    ^ reference (write) local 2~#2122680152
#    override_documentation
#    | ```ruby
#    | x (Integer(1))
#    | ```
   else
     x = nil
#    ^ reference (write) local 2~#2122680152
#    override_documentation
#    | ```ruby
#    | x (NilClass)
#    | ```
   end
   return
 end
 
 def loop_type_change(bs)
#    ^^^^^^^^^^^^^^^^ definition [..] Object#loop_type_change().
#    documentation
#    | ```ruby
#    | sig {params(bs: T.untyped).returns(T.untyped)}
#    | def loop_type_change(bs)
#    | ```
#                     ^^ definition local 1~#4057334513
#                     documentation
#                     | ```ruby
#                     | bs (T.untyped)
#                     | ```
   x = nil
#  ^ definition local 2~#4057334513
#  documentation
#  | ```ruby
#  | x (NilClass)
#  | ```
   for b in bs
#      ^ definition local 3~#4057334513
#      documentation
#      | ```ruby
#      | b (T.untyped)
#      | ```
#           ^^ reference local 1~#4057334513
     puts x
#    ^^^^ reference [..] Kernel#puts().
#         ^ reference local 2~#4057334513
     if b
       x = 1
#      ^ reference (write) local 2~#4057334513
#      override_documentation
#      | ```ruby
#      | x (T.untyped)
#      | ```
#      ^^^^^ reference local 2~#4057334513
#      override_documentation
#      | ```ruby
#      | x = 1 (T.untyped)
#      | ```
     else
       x = 's'
#      ^ reference (write) local 2~#4057334513
#      override_documentation
#      | ```ruby
#      | x (T.untyped)
#      | ```
#      ^^^^^^^ reference local 2~#4057334513
#      override_documentation
#      | ```ruby
#      | x = 's' (T.untyped)
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
#  ^^ definition [..] `<Class:C>`#`@k`.
#  documentation
#  | ```ruby
#  | @k (T.untyped)
#  | ```
 
   def change_type(b)
#      ^^^^^^^^^^^ definition [..] C#change_type().
#      documentation
#      | ```ruby
#      | sig {params(b: T.untyped).returns(T.untyped)}
#      | def change_type(b)
#      | ```
#                  ^ definition local 1~#2066187318
#                  documentation
#                  | ```ruby
#                  | b (T.untyped)
#                  | ```
     @f = nil
#    ^^ definition [..] C#`@f`.
     @@g = nil
#    ^^^ definition [..] `<Class:C>`#`@@g`.
     @k = nil
#    ^^ definition [..] C#`@k`.
     if b
       @f = 1
#      ^^ reference (write) [..] C#`@f`.
#      override_documentation
#      | ```ruby
#      | @f (Integer(1))
#      | ```
       @@g = 1
#      ^^^ reference (write) [..] `<Class:C>`#`@@g`.
#      override_documentation
#      | ```ruby
#      | @@g (Integer(1))
#      | ```
       @k = 1
#      ^^ reference (write) [..] C#`@k`.
#      override_documentation
#      | ```ruby
#      | @k (Integer(1))
#      | ```
#      ^^^^^^ reference [..] C#`@k`.
#      override_documentation
#      | ```ruby
#      | @k (Integer(1))
#      | ```
     else
       @f = 'f'
#      ^^ reference (write) [..] C#`@f`.
#      override_documentation
#      | ```ruby
#      | @f (String("f"))
#      | ```
       @@g = 'g'
#      ^^^ reference (write) [..] `<Class:C>`#`@@g`.
#      override_documentation
#      | ```ruby
#      | @@g (String("g"))
#      | ```
       @k = 'k'
#      ^^ reference (write) [..] C#`@k`.
#      override_documentation
#      | ```ruby
#      | @k (String("k"))
#      | ```
#      ^^^^^^^^ reference [..] C#`@k`.
#      override_documentation
#      | ```ruby
#      | @k (String("k"))
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
#      ^^^^^^^^^^^ definition [..] D#change_type().
#      documentation
#      | ```ruby
#      | sig {params(b: T.untyped).returns(T.untyped)}
#      | def change_type(b)
#      | ```
#                  ^ definition local 1~#2066187318
#                  documentation
#                  | ```ruby
#                  | b (T.untyped)
#                  | ```
     if !b
#       ^ reference [..] BasicObject#`!`().
#        ^ reference local 1~#2066187318
       @f = 1
#      ^^ definition [..] D#`@f`.
#      documentation
#      | ```ruby
#      | @f (T.untyped)
#      | ```
#      relation definition=[..] C#`@f`.
       @@g = 1
#      ^^^ definition [..] `<Class:D>`#`@@g`.
#      documentation
#      | ```ruby
#      | @@g (T.untyped)
#      | ```
#      relation definition=[..] `<Class:C>`#`@@g`.
       @k = 1
#      ^^ definition [..] D#`@k`.
#      relation definition=[..] C#`@k`.
#      ^^^^^^ reference [..] D#`@k`.
#      override_documentation
#      | ```ruby
#      | @k (Integer(1))
#      | ```
#      relation definition=[..] C#`@k`.
     else
       @f = 'f'
#      ^^ definition [..] D#`@f`.
#      documentation
#      | ```ruby
#      | @f (T.untyped)
#      | ```
#      relation definition=[..] C#`@f`.
       @@g = 'g'
#      ^^^ definition [..] `<Class:D>`#`@@g`.
#      documentation
#      | ```ruby
#      | @@g (T.untyped)
#      | ```
#      relation definition=[..] `<Class:C>`#`@@g`.
       @k = 'k'
#      ^^ definition [..] D#`@k`.
#      relation definition=[..] C#`@k`.
#      ^^^^^^^^ reference [..] D#`@k`.
#      override_documentation
#      | ```ruby
#      | @k (String("k"))
#      | ```
#      relation definition=[..] C#`@k`.
     end
   end
 end
