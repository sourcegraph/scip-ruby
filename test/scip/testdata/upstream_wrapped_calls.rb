# typed: true
# check-errors: true
# Adapted from test/testdata/infer/call_with_block.rb.

class WrappedCalls
  extend T::Sig

  sig { params(value: Integer, blk: T.proc.returns(Integer)).returns(Integer) }
  def target(value, &blk)
    value + blk.call
  end

  sig { params(value: Integer, blk: T.nilable(T.proc.returns(Integer))).returns(Integer) }
  def plain(value, &blk)
    value
  end

  sig { params(value: Integer, blk: T.proc.params(value: Integer).returns(String)).returns(String) }
  def convert(value, &blk)
    blk.call(value)
  end

  sig { params(other: WrappedCalls, value: Integer, blk: T.proc.returns(Integer)).void }
  def named(other, value, &blk)
    target(value, &blk)
    other.target(value, &blk)
    target(*[value], &blk)
    other.target(*[value], &blk)
    target(*[value]) { blk.call }
    other.target(*[value]) { blk.call }
    other.plain(*[value])
    other.plain(value, &nil)
    other.plain(*[value], &nil)

    other.target(
      *[value],
      &blk
    )
  end

  sig { params("&": T.proc.returns(Integer)).void }
  def anonymous(&)
    target(1, &)
    target(*[1], &)
  end

  sig { params(value: Integer).void }
  def symbols(value)
    convert(*[value], &:to_s)
    convert(*[value], &:"to_s")
    convert(*[value], &:'to_s')
  end

  sig { params(array: T::Array[Integer], value: Integer).void }
  def indexed(array, value)
    array[0]
    array[*[0]]
    array.[](*[0])
    array[*[0]] = value
    array.[]=(*[0, value])
  end

  sig { params(other: T.untyped, blk: T.proc.returns(Integer)).void }
  def unresolved(other, &blk)
    other.target(1, &blk)
    other.target(*[1], &blk)
    other.target(*[1]) { blk.call }
  end
end
