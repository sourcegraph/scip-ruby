# typed: true

# Parentheses can put the outer constant before its unresolved scope in the
# source-range ordering used when reporting missing constants.
(MissingNamespace::Child)::Grandchild
((MissingNested::Child)::Grandchild)::Leaf

module KnownNamespace
  class Existing
  end
end

(KnownNamespace::Missing)::Child

# Preserve aliases as written scopes, even when their targets are unresolved.
AliasToKnown = KnownNamespace
AliasToKnown::Missing
AliasToMissing = MissingAliasTarget
AliasToMissing::Child

class IndexedAfterMissingConstants
  extend T::Sig

  # Exercise reconstruction of the unresolved path during signature resolution.
  sig { returns((MissingSignature::Child)::Grandchild) }
  def unresolved_return
    raise
  end

  sig { returns(AliasToMissing::Child) }
  def unresolved_alias_return
    raise
  end

  def value
    1
  end
end

# Missing constants must not prevent indexing the definitions that do resolve.
KnownNamespace::Existing.new
IndexedAfterMissingConstants.new.value
