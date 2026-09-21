# typed: true

# Minimal stub of Chalk implementation to support encrypted_prop
class Chalk::ODM::Document
end
class Opus::DB::Model::Mixins::Encryptable::EncryptedValue < Chalk::ODM::Document
end

class EncryptedProp
  include T::Props
  def self.encrypted_prop(opts={}); end
  encrypted_prop :foo
  encrypted_prop :bar, migrating: true, immutable: true
end


def f
  EncryptedProp.new.foo = "hello"
  EncryptedProp.new.foo = nil
  return EncryptedProp.new.encrypted_foo
end
