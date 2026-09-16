 # typed: true
 
 # Parentheses can put the outer constant before its unresolved scope in the
 # source-range ordering used when reporting missing constants.
 (MissingNamespace::Child)::Grandchild
 ((MissingNested::Child)::Grandchild)::Leaf
 
#⌄ enclosing_range_start [..] KnownNamespace#
 module KnownNamespace
#       ^^^^^^^^^^^^^^ definition [..] KnownNamespace#
#  ⌄ enclosing_range_start [..] KnownNamespace#Existing#
   class Existing
#        ^^^^^^^^ definition [..] KnownNamespace#Existing#
   end
#    ⌃ enclosing_range_end [..] KnownNamespace#Existing#
 end
#  ⌃ enclosing_range_end [..] KnownNamespace#
 
 (KnownNamespace::Missing)::Child
# ^^^^^^^^^^^^^^ reference [..] KnownNamespace#
 
 # Preserve aliases as written scopes, even when their targets are unresolved.
 AliasToKnown = KnownNamespace
#^^^^^^^^^^^^ definition [..] AliasToKnown.
#relation reference=[..] KnownNamespace#
#               ^^^^^^^^^^^^^^ reference [..] KnownNamespace#
 AliasToKnown::Missing
#^^^^^^^^^^^^ reference [..] AliasToKnown.
 AliasToMissing = MissingAliasTarget
#^^^^^^^^^^^^^^ definition [..] AliasToMissing.
#relation reference=
 AliasToMissing::Child
#^^^^^^^^^^^^^^ reference [..] AliasToMissing.
 
#⌄ enclosing_range_start [..] IndexedAfterMissingConstants#
 class IndexedAfterMissingConstants
#      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] IndexedAfterMissingConstants#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   # Exercise reconstruction of the unresolved path during signature resolution.
   sig { returns((MissingSignature::Child)::Grandchild) }
#  ⌄ enclosing_range_start [..] IndexedAfterMissingConstants#unresolved_return().
   def unresolved_return
#      ^^^^^^^^^^^^^^^^^ definition [..] IndexedAfterMissingConstants#unresolved_return().
     raise
#    ^^^^^ reference [..] Kernel#raise().
   end
#    ⌃ enclosing_range_end [..] IndexedAfterMissingConstants#unresolved_return().
 
   sig { returns(AliasToMissing::Child) }
#                ^^^^^^^^^^^^^^ reference [..] AliasToMissing.
#  ⌄ enclosing_range_start [..] IndexedAfterMissingConstants#unresolved_alias_return().
   def unresolved_alias_return
#      ^^^^^^^^^^^^^^^^^^^^^^^ definition [..] IndexedAfterMissingConstants#unresolved_alias_return().
     raise
#    ^^^^^ reference [..] Kernel#raise().
   end
#    ⌃ enclosing_range_end [..] IndexedAfterMissingConstants#unresolved_alias_return().
 
#  ⌄ enclosing_range_start [..] IndexedAfterMissingConstants#value().
   def value
#      ^^^^^ definition [..] IndexedAfterMissingConstants#value().
     1
   end
#    ⌃ enclosing_range_end [..] IndexedAfterMissingConstants#value().
 end
#  ⌃ enclosing_range_end [..] IndexedAfterMissingConstants#
 
 # Missing constants must not prevent indexing the definitions that do resolve.
 KnownNamespace::Existing.new
#^^^^^^^^^^^^^^ reference [..] KnownNamespace#
#                ^^^^^^^^ reference [..] KnownNamespace#Existing#
#                         ^^^ reference [..] Class#new().
 IndexedAfterMissingConstants.new.value
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] IndexedAfterMissingConstants#
#                             ^^^ reference [..] Class#new().
#                                 ^^^^^ reference [..] IndexedAfterMissingConstants#value().
