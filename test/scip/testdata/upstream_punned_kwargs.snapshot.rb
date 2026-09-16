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
#                 ^^^ definition local 1$1854267817
#                 documentation
#                 | ```ruby
#                 | xyz (String)
#                 | ```
   xyz
#  ^^^ reference local 1$1854267817
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
 takes_string(xyz: xyz)
#^^^^^^^^^^^^ reference [..] Object#takes_string().
#                  ^^^ reference local 4$119448696
