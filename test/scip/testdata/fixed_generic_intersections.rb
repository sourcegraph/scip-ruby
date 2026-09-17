# typed: true
# check-errors: true
# options: showDocs

class FixedHash < Hash
  extend T::Generic
  K = type_member { { fixed: Symbol } }
  V = type_member { { fixed: Object } }
  Elem = type_member { { fixed: [Symbol, Object] } }

  def custom_method; 'custom'; end
end

extend T::Sig
sig { params(value: T.all(FixedHash, T::Hash[Symbol, String])).void }
def child_first(value)
  value.fetch(:version).upcase
  value.custom_method.upcase
end

sig { params(value: T.all(T::Hash[Symbol, String], FixedHash)).void }
def parent_first(value)
  value.fetch(:version).upcase
  value.custom_method.upcase
end

sig { params(value: T.any(FixedHash, T::Hash[Symbol, String])).void }
def narrowing(value)
  if value.is_a?(FixedHash)
    value.custom_method.upcase
  else
    value.fetch(:version).to_s.upcase
  end
end

# Parent members that are still covariant can retain their narrower types.
sig { params(value: T.all(T::Hash[Symbol, Object], T::Hash[Symbol, String])).void }
def ordinary_covariance(value)
  value.fetch(:version).upcase
end

# An invariant child obtained by is_a? starts with an untyped member. It can
# still be refined from the typed ancestor without violating subtyping.
class CovariantResult
  extend T::Generic
  extend T::Sig
  Value = type_member(:out)

  sig { returns(Value) }
  def value; T.unsafe(nil); end
end

class InvariantResult < CovariantResult
  Value = type_member
end

sig { params(result: CovariantResult[String]).void }
def refine_untyped_member(result)
  if result.is_a?(InvariantResult)
    result.value.upcase
  end
end

sig { params(result: CovariantResult[T::Array[String]]).void }
def refine_aggregate_member(result)
  if result.is_a?(InvariantResult)
    result.value.join(', ').upcase
  end
end
