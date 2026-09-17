# typed: true
# check-errors: true
# options: showDocs

# File-level lambdas share the static initializer's CFG.
display_name = lambda do |name|
  return name unless name.include?("::")
  name.split("::").first
end
display_name.call("provider")

class ReturnOperands
  extend T::Sig

  sig { params(value: String, condition: T::Boolean).returns(String) }
  def guarded(value, condition)
    return(value) if condition
    [1].each { return value }
    value
  end

  sig { params(value: String).returns(String) }
  def block_exits(value)
    [1].each { next value }
    -> { return value }.call
  end
end
