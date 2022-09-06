# typed: strict

class CR
  extend T::Sig
  cattr_reader :both, :foo
  cattr_reader :no_instance, instance_accessor: false
  cattr_reader :bar, :no_reader, instance_reader: false

  sig {void}
  def usages
    both
  end

  both
  no_instance
  no_reader
end

class CW
  extend T::Sig
  cattr_writer :both, :foo
  cattr_writer :no_instance, instance_accessor: false
  cattr_writer :bar, :no_instance_writer, instance_writer: false

  sig {void}
  def usages
    self.both = 1
  end

  self.both = 1
  self.no_instance = 1
  self.no_instance_writer = 1
end

class CA
  extend T::Sig
  cattr_accessor :both, :foo
  cattr_accessor :no_instance, instance_accessor: false
  cattr_accessor :no_instance_reader, instance_reader: false
  cattr_accessor :bar, :no_instance_writer, instance_writer: false

  sig {void}
  def usages
    both
    self.both = 1
    self.no_instance_reader= 1
    no_instance_writer
  end

  both
  self.both = 1

  no_instance
  self.no_instance = 1

  no_instance_reader
  self.no_instance_reader = 1

  no_instance_writer
  self.no_instance_writer = 1
end
