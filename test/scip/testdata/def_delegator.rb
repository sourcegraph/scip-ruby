# typed: true

require 'forwardable'

class MyArray1
  attr_accessor :inner_array
  extend Forwardable
  def_delegator :@inner_array, :[], :get_at_index
end

class MyArray2
  extend T::Sig
  attr_accessor :inner_array
  extend Forwardable
  def_delegator :@inner_array, :[], :get_at_index
end

class MyArray3
  attr_accessor :inner_array
  extend Forwardable
  def_delegators :@inner_array, :size, :<<, :map
end

class MyArray4
  extend T::Sig
  attr_accessor :inner_array
  extend Forwardable
  def_delegators :@inner_array, :size, :<<, :map
end
