# typed: true
extend T::Sig

# New inference retains tuple/shape types here instead of Array/Hash.
module RetainedReceiverTypes
  VALUES = %w[a b].freeze

  def self.copy
    VALUES.dup
    VALUES.inspect
    VALUES.freeze
    options = {x: 1, y: 2}
    options.keys
    options.delete(:x)
  end
end

sig { params(value: T.anything).void }
def any_value(value)
  value.instance_variable_get(:@data)
  value.inspect
  value.to_s
  value.no_such_method
end

# Do not treat a known BasicObject as Object.
sig { params(value: BasicObject).void }
def basic_value(value)
  value.instance_variable_get(:@data)
end

sig { void }
def implicit_block
  yield if block_given?
end

sig { params(block: T.nilable(T.proc.void)).void }
def explicit_block(&block)
  yield if block_given?
end
