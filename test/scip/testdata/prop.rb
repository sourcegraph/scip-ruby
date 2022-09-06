# typed: true

class SomeODM
    extend T::Sig
    include T::Props

    prop :foo, String

    sig {returns(T.nilable(String))}
    def foo2; T.cast(T.unsafe(nil), T.nilable(String)); end
    sig {params(arg0: String).returns(String)}
    def foo2=(arg0); T.cast(nil, String); end
end

class ForeignClass
end

class AdvancedODM
    include T::Props
    prop :default, String, default: ""
    prop :t_nilable, T.nilable(String)

    prop :array, Array
    prop :t_array, T::Array[String]
    prop :hash_of, T::Hash[Symbol, String]

    prop :const_explicit, String, immutable: true
    const :const, String

    prop :enum_prop, String, enum: ["hello", "goodbye"]

    prop :foreign_lazy, String, foreign: -> {ForeignClass}
    prop :foreign_proc, String, foreign: proc {ForeignClass}
    prop :foreign_invalid, String, foreign: proc { :not_a_type }

    prop :ifunset, String, ifunset: ''
    prop :ifunset_nilable, T.nilable(String), ifunset: ''

    prop :empty_hash_rules, String, {}
    prop :hash_rules, String, { enum: ["hello", "goodbye" ] }
end

class PropHelpers
  include T::Props
  def self.token_prop(opts={}); end
  def self.created_prop(opts={}); end
  token_prop
  created_prop
end

class PropHelpers2
  include T::Props
  def self.timestamped_token_prop(opts={}); end
  def self.created_prop(opts={}); end
  timestamped_token_prop
  created_prop(immutable: true)
end

def main
    SomeODM.new.foo
    SomeODM.new.foo = 'b'
    SomeODM.new.foo2
    SomeODM.new.foo2 = 'b'

    AdvancedODM.new.default
    AdvancedODM.new.t_nilable

    AdvancedODM.new.t_array
    AdvancedODM.new.hash_of

    AdvancedODM.new.const_explicit
    AdvancedODM.new.const_explicit = 'b'
    AdvancedODM.new.const
    AdvancedODM.new.const = 'b'

    AdvancedODM.new.enum_prop
    AdvancedODM.new.enum_prop = "hello"

    AdvancedODM.new.foreign_
    AdvancedODM.new.foreign_
    AdvancedODM.new.foreign_lazy_

    # Check that the method still exists even if we can't parse the type
    AdvancedODM.new.foreign_invalid_

    PropHelpers.new.token
    PropHelpers.new.token = "tok_token"
    PropHelpers.new.token = nil

    PropHelpers.new.created
    PropHelpers.new.created = 0.0
    PropHelpers.new.created = nil

    PropHelpers2.new.token
    PropHelpers2.new.token = "tok_token"
    PropHelpers2.new.token = nil

    PropHelpers2.new.created
    PropHelpers2.new.created = 0.0

    AdvancedODM.new.ifunset
    AdvancedODM.new.ifunset_nilable
    AdvancedODM.new.ifunset = nil
    AdvancedODM.new.ifunset_nilable = nil
end
