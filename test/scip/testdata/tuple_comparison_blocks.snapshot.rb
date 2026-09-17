 # typed: true
 # check-errors: true
 # options: showDocs
 
 values = ['a', 'long']
#^^^^^^ definition local 1$217974539
#documentation
#| ```ruby
#| values ([String("a"), String("long")])
#| ```
 minimum = values.min { |left, right| left.length <=> right.length }
#^^^^^^^ definition local 4$217974539
#documentation
#| ```ruby
#| minimum (T.nilable(String))
#| ```
#          ^^^^^^ reference local 1$217974539
#                 ^^^ reference [..] Enumerable#min().
#                        ^^^^ definition local 2$217974539
#                        documentation
#                        | ```ruby
#                        | left (String)
#                        | ```
#                              ^^^^^ definition local 3$217974539
#                              documentation
#                              | ```ruby
#                              | right (String)
#                              | ```
#                                     ^^^^ reference local 2$217974539
#                                          ^^^^^^ reference [..] String#length().
#                                                 ^^^ reference [..] Integer#`<=>`().
#                                                     ^^^^^ reference local 3$217974539
#                                                           ^^^^^^ reference [..] String#length().
 maximum = values.max { |left, right| left.length <=> right.length }
#^^^^^^^ definition local 7$217974539
#documentation
#| ```ruby
#| maximum (T.nilable(String))
#| ```
#          ^^^^^^ reference local 1$217974539
#                 ^^^ reference [..] Enumerable#max().
#                        ^^^^ definition local 5$217974539
#                        documentation
#                        | ```ruby
#                        | left (String)
#                        | ```
#                              ^^^^^ definition local 6$217974539
#                              documentation
#                              | ```ruby
#                              | right (String)
#                              | ```
#                                     ^^^^ reference local 5$217974539
#                                          ^^^^^^ reference [..] String#length().
#                                                 ^^^ reference [..] Integer#`<=>`().
#                                                     ^^^^^ reference local 6$217974539
#                                                           ^^^^^^ reference [..] String#length().
 minimum&.upcase
#^^^^^^^ reference local 4$217974539
#override_documentation
#| ```ruby
#| minimum (T.nilable(String))
#| ```
#         ^^^^^^ reference [..] String#upcase().
 maximum&.downcase
#^^^^^^^ reference local 7$217974539
#override_documentation
#| ```ruby
#| maximum (T.nilable(String))
#| ```
#         ^^^^^^^^ reference [..] String#downcase().
 
 # Positional-count calls already use ordinary Array dispatch.
 values.min(2) { |left, right| left.length <=> right.length }.each(&:upcase)
#^^^^^^ reference local 1$217974539
#       ^^^ reference [..] Enumerable#min().
#                 ^^^^ definition local 8$217974539
#                 documentation
#                 | ```ruby
#                 | left (String)
#                 | ```
#                       ^^^^^ definition local 9$217974539
#                       documentation
#                       | ```ruby
#                       | right (String)
#                       | ```
#                              ^^^^ reference local 8$217974539
#                                   ^^^^^^ reference [..] String#length().
#                                          ^^^ reference [..] Integer#`<=>`().
#                                              ^^^^^ reference local 9$217974539
#                                                    ^^^^^^ reference [..] String#length().
#                                                             ^^^^ reference [..] Array#each().
#                                                                    ^^^^^^ reference [..] String#upcase().
 values.max(2) { |left, right| left.length <=> right.length }.each(&:downcase)
#^^^^^^ reference local 1$217974539
#       ^^^ reference [..] Enumerable#max().
#                 ^^^^ definition local 10$217974539
#                 documentation
#                 | ```ruby
#                 | left (String)
#                 | ```
#                       ^^^^^ definition local 11$217974539
#                       documentation
#                       | ```ruby
#                       | right (String)
#                       | ```
#                              ^^^^ reference local 10$217974539
#                                   ^^^^^^ reference [..] String#length().
#                                          ^^^ reference [..] Integer#`<=>`().
#                                              ^^^^^ reference local 11$217974539
#                                                    ^^^^^^ reference [..] String#length().
#                                                             ^^^^ reference [..] Array#each().
#                                                                    ^^^^^^^^ reference [..] String#downcase().
 
 # Empty receivers still typecheck their comparator without an internal error.
 [].min { |left, right| 0 }
#   ^^^ reference [..] Enumerable#min().
#          ^^^^ definition local 12$217974539
#          documentation
#          | ```ruby
#          | left (T.untyped)
#          | ```
#                ^^^^^ definition local 13$217974539
#                documentation
#                | ```ruby
#                | right (T.untyped)
#                | ```
 [].max { |left, right| 0 }
#   ^^^ reference [..] Enumerable#max().
#          ^^^^ definition local 14$217974539
#          documentation
#          | ```ruby
#          | left (T.untyped)
#          | ```
#                ^^^^^ definition local 15$217974539
#                documentation
#                | ```ruby
#                | right (T.untyped)
#                | ```
 
 # Preserve the precise, non-nil result for the existing no-block shortcut.
 values.min.upcase
#^^^^^^ reference local 1$217974539
#       ^^^ reference [..] Enumerable#min().
#           ^^^^^^ reference [..] String#upcase().
 values.max.downcase
#^^^^^^ reference local 1$217974539
#       ^^^ reference [..] Enumerable#max().
#           ^^^^^^^^ reference [..] String#downcase().
