# typed: true
# check-errors: true

class MissingDSL
  def ordinary
    'still indexed'
  end
end

value = MissingDSL.new
value.sig # error: Method `sig` does not exist
value.abstract! # error: Method `abstract!` does not exist on `MissingDSL`
value.final! # error: Method `final!` does not exist on `MissingDSL`
value.sealed! # error: Method `sealed!` does not exist on `MissingDSL`
value.type_member # error: Method `type_member` does not exist on `MissingDSL`
value.ordinary.upcase

# Ordinary class-level DSL use remains supported.
class HasDSL
  extend T::Sig
  sig { returns(String) }
  def ordinary
    'typed'
  end
end
HasDSL.new.ordinary.upcase
