 # typed: true
 # options: showDocs
 
#⌄ enclosing_range_start [..] BinaryHover#
 class BinaryHover
#      ^^^^^^^^^^^ definition [..] BinaryHover#
#      documentation
#      | ```ruby
#      | class BinaryHover
#      | ```
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { void }
#  ⌄ enclosing_range_start [..] `<Class:BinaryHover>`#values().
   def self.values
#           ^^^^^^ definition [..] `<Class:BinaryHover>`#values().
#           documentation
#           | ```ruby
#           | sig { void }
#           | def self.values
#           | ```
     text = "\xff"
#    ^^^^ definition local 1$4258568815
#    documentation
#    | ```ruby
#    | text (String("\377"))
#    | ```
     puts text
#    ^^^^ reference [..] Kernel#puts().
#         ^^^^ reference local 1$4258568815
     text = "\xc3("
#    ^^^^ reference (write) local 1$4258568815
#    override_documentation
#    | ```ruby
#    | text (String("\303("))
#    | ```
     puts text
#    ^^^^ reference [..] Kernel#puts().
#         ^^^^ reference local 1$4258568815
#         override_documentation
#         | ```ruby
#         | text (String("\303("))
#         | ```
     text = "café 日本語 😀"
#    ^^^^ reference (write) local 1$4258568815
#    override_documentation
#    | ```ruby
#    | text (String("café 日本語 😀"))
#    | ```
     puts text
#    ^^^^ reference [..] Kernel#puts().
#         ^^^^ reference local 1$4258568815
#         override_documentation
#         | ```ruby
#         | text (String("café 日本語 😀"))
#         | ```
     binary_symbol = :"\xff"
#    ^^^^^^^^^^^^^ definition local 2$4258568815
#    documentation
#    | ```ruby
#    | binary_symbol (Symbol(:\377))
#    | ```
     puts binary_symbol
#    ^^^^ reference [..] Kernel#puts().
#         ^^^^^^^^^^^^^ reference local 2$4258568815
     bytes = ["\xff", "é"]
#    ^^^^^ definition local 3$4258568815
#    documentation
#    | ```ruby
#    | bytes ([String("\377"), String("é")])
#    | ```
     puts bytes
#    ^^^^ reference [..] Kernel#puts().
#         ^^^^^ reference local 3$4258568815
   end
#    ⌃ enclosing_range_end [..] `<Class:BinaryHover>`#values().
 end
#  ⌃ enclosing_range_end [..] BinaryHover#
 
 BinaryHover.values
#^^^^^^^^^^^ reference [..] BinaryHover#
#            ^^^^^^ reference [..] `<Class:BinaryHover>`#values().
