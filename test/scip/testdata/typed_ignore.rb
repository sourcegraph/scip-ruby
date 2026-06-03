# typed: ignore

# `typed: ignore` files are parsed but not typechecked. This locks in what
# (if anything) the indexer emits for such files.

class IgnoredKlass
  def m
    @field = 1
  end
end

IgnoredKlass.new.m
