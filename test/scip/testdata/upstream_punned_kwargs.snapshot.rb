 # typed: true
 # options: showDocs
 # Adapted from test/testdata/lsp/punned_kwargs.rb.
 
 extend T::Sig
#^^^^^^ reference [..] Kernel#extend().
#       ^ reference [..] T#
#          ^^^ reference [..] T#Sig#
 
 sig { params(xyz: String).returns(String) }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                  ^^^^^^ reference [..] String#
#                          ^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#                                  ^^^^^^ reference [..] String#
#⌄ enclosing_range_start [..] Object#takes_string().
 def takes_string(xyz:)
#    ^^^^^^^^^^^^ definition [..] Object#takes_string().
#    documentation
#    | ```ruby
#    | sig { params(xyz: String).returns(String) }
#    | def takes_string(xyz:)
#    | ```
#                 ^^^ definition [..] Object#takes_string().(xyz)
#                 documentation
#                 | ```ruby
#                 | xyz (String)
#                 | ```
   xyz
#  ^^^ reference [..] Object#takes_string().(xyz)
 end
#  ⌃ enclosing_range_end [..] Object#takes_string().
 
 xyz = "hello"
#^^^ definition local 4$119448696
#documentation
#| ```ruby
#| xyz (String("hello"))
#| ```
 takes_string(xyz:)
#^^^^^^^^^^^^ reference [..] Object#takes_string().
#             ^^^ reference local 4$119448696
#             ^^^ reference [..] Object#takes_string().(xyz)
 takes_string(xyz: xyz)
#^^^^^^^^^^^^ reference [..] Object#takes_string().
#             ^^^ reference [..] Object#takes_string().(xyz)
#                  ^^^ reference local 4$119448696
