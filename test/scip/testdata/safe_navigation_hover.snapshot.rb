 # typed: true
 # options: showDocs
 
#⌄ enclosing_range_start [..] SafeNavigationHover#
 class SafeNavigationHover
#      ^^^^^^^^^^^^^^^^^^^ definition [..] SafeNavigationHover#
#      documentation
#      | ```ruby
#      | class SafeNavigationHover
#      | ```
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(value: String, maybe: T.nilable(String), absent: NilClass).void }
#                      ^^^^^^ reference [..] String#
#                                               ^^^^^^ reference [..] String#
#                                                                ^^^^^^^^ reference [..] NilClass#
#  ⌄ enclosing_range_start [..] SafeNavigationHover#example().
   def example(value, maybe, absent)
#      ^^^^^^^ definition [..] SafeNavigationHover#example().
#      documentation
#      | ```ruby
#      | sig { params(value: String, maybe: T.nilable(String), absent: NilClass).void }
#      | def example(value, maybe, absent)
#      | ```
#              ^^^^^ definition local 1$1962486713
#              documentation
#              | ```ruby
#              | value (String)
#              | ```
#                     ^^^^^ definition local 2$1962486713
#                     documentation
#                     | ```ruby
#                     | maybe (T.nilable(String))
#                     | ```
#                            ^^^^^^ definition local 3$1962486713
#                            documentation
#                            | ```ruby
#                            | absent (NilClass)
#                            | ```
     # The dead nil path must not hide the live assignment's type, even if unused.
     unused_length = value&.length
#    ^^^^^^^^^^^^^ definition local 4$1962486713
#    documentation
#    | ```ruby
#    | unused_length (Integer)
#    | ```
#                    ^^^^^ reference local 1$1962486713
#                           ^^^^^^ reference [..] String#length().
     used_length = value&.length
#    ^^^^^^^^^^^ definition local 5$1962486713
#    documentation
#    | ```ruby
#    | used_length (Integer)
#    | ```
#                  ^^^^^ reference local 1$1962486713
#                         ^^^^^^ reference [..] String#length().
     puts used_length
#    ^^^^ reference [..] Kernel#puts().
#         ^^^^^^^^^^^ reference local 5$1962486713
 
     # Both reachable paths contribute to the definition hover.
     nullable_length = maybe&.length
#    ^^^^^^^^^^^^^^^ definition local 6$1962486713
#    documentation
#    | ```ruby
#    | nullable_length (T.nilable(Integer))
#    | ```
#                      ^^^^^ reference local 2$1962486713
#                      override_documentation
#                      | ```ruby
#                      | maybe (T.nilable(String))
#                      | ```
#                             ^^^^^^ reference [..] String#length().
     puts nullable_length
#    ^^^^ reference [..] Kernel#puts().
#         ^^^^^^^^^^^^^^^ reference local 6$1962486713
#         override_documentation
#         | ```ruby
#         | nullable_length (T.nilable(Integer))
#         | ```
     always_nil = absent&.length
#    ^^^^^^^^^^ definition local 7$1962486713
#    documentation
#    | ```ruby
#    | always_nil (NilClass)
#    | ```
#                 ^^^^^^ reference local 3$1962486713
     puts always_nil
#    ^^^^ reference [..] Kernel#puts().
#         ^^^^^^^^^^ reference local 7$1962486713
 
     # A later assignment must not change the first definition's hover.
     reassigned = value&.length
#    ^^^^^^^^^^ definition local 8$1962486713
#    documentation
#    | ```ruby
#    | reassigned (Integer)
#    | ```
#                 ^^^^^ reference local 1$1962486713
#                        ^^^^^^ reference [..] String#length().
     reassigned = 'changed'
#    ^^^^^^^^^^ reference (write) local 8$1962486713
#    override_documentation
#    | ```ruby
#    | reassigned (String("changed"))
#    | ```
     puts reassigned
#    ^^^^ reference [..] Kernel#puts().
#         ^^^^^^^^^^ reference local 8$1962486713
#         override_documentation
#         | ```ruby
#         | reassigned (String("changed"))
#         | ```
 
     # Nilability also applies to aggregate return types.
     chars = maybe&.chars
#    ^^^^^ definition local 9$1962486713
#    documentation
#    | ```ruby
#    | chars (T.nilable(T::Array[String]))
#    | ```
#            ^^^^^ reference local 2$1962486713
#            override_documentation
#            | ```ruby
#            | maybe (T.nilable(String))
#            | ```
#                   ^^^^^ reference [..] String#chars().
     puts chars
#    ^^^^ reference [..] Kernel#puts().
#         ^^^^^ reference local 9$1962486713
#         override_documentation
#         | ```ruby
#         | chars (T.nilable(T::Array[String]))
#         | ```
     chained = maybe&.strip&.length
#    ^^^^^^^ definition local 10$1962486713
#    documentation
#    | ```ruby
#    | chained (T.nilable(Integer))
#    | ```
#              ^^^^^ reference local 2$1962486713
#              override_documentation
#              | ```ruby
#              | maybe (T.nilable(String))
#              | ```
#                     ^^^^^ reference [..] String#strip().
#                            ^^^^^^ reference [..] String#length().
     puts chained
#    ^^^^ reference [..] Kernel#puts().
#         ^^^^^^^ reference local 10$1962486713
#         override_documentation
#         | ```ruby
#         | chained (T.nilable(Integer))
#         | ```
   end
#    ⌃ enclosing_range_end [..] SafeNavigationHover#example().
 end
#  ⌃ enclosing_range_end [..] SafeNavigationHover#
