# typed: true
# check-errors: true
# Adapted from test/prism_regression/target_nodes.rb.

class AssignmentTargets
  extend T::Sig

  sig { params(value: Integer).returns(Integer) }
  def value=(value)
    value
  end

  sig { params(error: StandardError).returns(StandardError) }
  def error=(error)
    error
  end

  sig { params(key: Symbol, value: T.any(Integer, StandardError)).returns(T.any(Integer, StandardError)) }
  def []=(key, value)
    value
  end
end

target = AssignmentTargets.new

for target.value in [1, 2]
  target.value = 3
end

for target[:value] in [1, 2]
  target[:value] = 3
end

begin
  raise "property target"
rescue StandardError => target.error
  target.error = StandardError.new("handled")
end

begin
  raise "indexed target"
rescue StandardError => target[:error]
  target[:error] = StandardError.new("handled")
end
