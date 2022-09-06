# typed: strict

class MR
  extend T::Sig
  mattr_reader :both, :foo
  mattr_reader :no_instance, instance_accessor: false
  mattr_reader :bar, :no_instance_reader, instance_reader: false

  sig {void}
  def usages
    both
  end

  both
  no_instance
  no_instance_reader
end

class MW
  extend T::Sig
  mattr_writer :both, :foo
  mattr_writer :no_instance, instance_accessor: false
  mattr_writer :bar, :no_instance_writer, instance_writer: false

  sig {void}
  def usages
    self.both = 1
  end

  self.both = 1
  self.no_instance = 1
  self.no_instance_writer = 1
end

class MA
  extend T::Sig
  mattr_accessor :both, :foo
  mattr_accessor :no_instance, instance_accessor: false
  mattr_accessor :no_instance_reader, instance_reader: false
  mattr_accessor :bar, :no_instance_writer, instance_writer: false

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
