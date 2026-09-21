# typed: true
# check-errors: true
class ReopenedMethod
  def value
    2
  end
end

ReopenedMethod.new.value
