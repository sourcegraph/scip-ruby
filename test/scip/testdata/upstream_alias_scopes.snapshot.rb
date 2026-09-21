 # typed: true
 # Adapted from test/testdata/lsp/alias_scopes.rb.
 
#⌄ enclosing_range_start [..] Bar#
 class Bar
#      ^^^ definition [..] Bar#
   Cnst = 1
#  ^^^^ definition [..] Bar#Cnst.
 end
#  ⌃ enclosing_range_end [..] Bar#
 
#⌄ enclosing_range_start [..] Foo#
 module Foo
#       ^^^ definition [..] Foo#
   Alias = Bar
#  ^^^^^ definition [..] Foo#Alias.
#  relation reference=[..] Bar#
#          ^^^ reference [..] Bar#
 
#  ⌄ enclosing_range_start [..] Foo#Other#
   module Other
#         ^^^^^ definition [..] Foo#Other#
     Alias = Bar
#    ^^^^^ definition [..] Foo#Other#Alias.
#    relation reference=[..] Bar#
#            ^^^ reference [..] Bar#
   end
#    ⌃ enclosing_range_end [..] Foo#Other#
 
   OtherAlias = Other
#  ^^^^^^^^^^ definition [..] Foo#OtherAlias.
#  relation reference=[..] Foo#Other#
#               ^^^^^ reference [..] Foo#Other#
   DeepAlias = OtherAlias::Alias
#  ^^^^^^^^^ definition [..] Foo#DeepAlias.
#  relation reference=[..] Foo#Other#Alias.
#              ^^^^^^^^^^ reference [..] Foo#OtherAlias.
#                          ^^^^^ reference [..] Foo#Other#Alias.
 end
#  ⌃ enclosing_range_end [..] Foo#
 
#⌄ enclosing_range_start [..] Foo#
 module Foo
#       ^^^ definition [..] Foo#
   Alias::Cnst
#  ^^^^^ reference [..] Foo#Alias.
#         ^^^^ reference [..] Bar#Cnst.
   DeepAlias::Cnst
#  ^^^^^^^^^ reference [..] Foo#DeepAlias.
#             ^^^^ reference [..] Bar#Cnst.
 end
#  ⌃ enclosing_range_end [..] Foo#
