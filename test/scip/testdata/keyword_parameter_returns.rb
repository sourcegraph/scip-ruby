# typed: true
# check-errors: true
# options: showDocs

class KeywordParameterReturns
  extend T::Sig

  sig { params(value: String, values: T.nilable(T::Array[String])).returns(String) }
  def guarded(value:, values: nil)
    return value if values.nil?
    return(value) if values.empty?
    value
  end

  sig { params(value: String).returns(String) }
  def nested(value:)
    [1].each { return value }
    value
  end

  sig { params(value: String).returns(String) }
  def block_exits(value:)
    [1].each { next value }
    -> { return value }.call
  end

  sig { params(value: String).returns(String) }
  def positional(value)
    return value
  end
end
