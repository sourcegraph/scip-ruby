 # typed: strict
 # enable-experimental-rbs-comments: true
 # options: showDocs
 
 # Adapted from test/testdata/rbs/signatures_defs.rb.
#⌄ enclosing_range_start [..] RBSParser#
 class RBSParser
#      ^^^^^^^^^ definition [..] RBSParser#
#      documentation
#      | ```ruby
#      | class RBSParser
#      | ```
#      documentation
#      | Adapted from test/testdata/rbs/signatures_defs.rb.
   #: -> String
#        ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] RBSParser#title().
   def title
#      ^^^^^ definition [..] RBSParser#title().
#      documentation
#      | ```ruby
#      | sig { returns(String) }
#      | def title
#      | ```
#      documentation
#      | : -> String
     "Prism"
   end
#    ⌃ enclosing_range_end [..] RBSParser#title().
 end
#  ⌃ enclosing_range_end [..] RBSParser#
 
 RBSParser.new.title.upcase
#^^^^^^^^^ reference [..] RBSParser#
#          ^^^ reference [..] Class#new().
#              ^^^^^ reference [..] RBSParser#title().
#                    ^^^^^^ reference [..] String#upcase().
