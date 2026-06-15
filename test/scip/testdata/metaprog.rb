# typed: false

# Common metaprogramming constructs. Currently not specially handled by the
# indexer (define_method body is a normal block; method_missing / respond_to_missing?
# are normal method defs).

class Dynamo
  define_method(:dynamic) do |x|
    x + 1
  end

  def method_missing(name, *args, &blk)
    "missed " + name.to_s
  end

  def respond_to_missing?(name, include_private = false)
    true
  end
end

def use_meta
  Dynamo.new.dynamic(1)
  Dynamo.new.unknown_method
end
