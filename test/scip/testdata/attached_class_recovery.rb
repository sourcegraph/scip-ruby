# typed: true

# Invalid has_attached_class! declarations and mixins can leave an attached-class
# type member behind after namer/resolver errors. Signatures must still index.
class DeclaresAttachedClass
  extend T::Sig
  extend T::Generic
  has_attached_class!

  sig { returns(T.attached_class) }
  def copy
    self
  end
end

# Module subclasses support has_attached_class! in current Sorbet.
class ModuleSubclass < Module
  extend T::Sig
  extend T::Generic
  has_attached_class!

  sig { returns(T.attached_class) }
  def copy
    self
  end
end

module AttachedClassFactory
  extend T::Sig
  extend T::Generic
  has_attached_class!

  sig { returns(T.attached_class) }
  def build
    T.unsafe(self).new
  end
end

class IncludesAttachedClass
  extend T::Sig
  include AttachedClassFactory

  sig { returns(T.attached_class) }
  def copy
    self
  end
end

# An invalid extension can also introduce the member on a module singleton.
module ExtendsAttachedClass
  extend T::Sig
  extend AttachedClassFactory

  sig { returns(T.attached_class) }
  def self.copy
    self
  end
end

# Valid module instance methods and class singleton methods keep their types.
class ValidFactory
  extend T::Sig
  extend AttachedClassFactory

  sig { returns(T.attached_class) }
  def self.copy
    new
  end

  def instance_method
  end
end

DeclaresAttachedClass.new.copy
ModuleSubclass.new.copy
IncludesAttachedClass.new.copy
ExtendsAttachedClass.copy
ValidFactory.build.instance_method
ValidFactory.copy.instance_method
