# typed: true

extend T::Sig

class IndexedWriter
  extend T::Sig

  sig { params(key: Symbol, value: String).returns(String) }
  def []=(key, value)
    value
  end
end

sig { params(hash: T::Hash[Symbol, String], array: T::Array[String], writer: IndexedWriter, value: String).void }
def indexed_assignment(hash, array, writer, value)
  hash[:key] = value
  array[0] = value
  writer[:key] = value
  hash.[]=(:explicit, value)
  hash[:default] ||= value
  hash[
    :multiline
  ] = value
end
