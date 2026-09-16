# typed: true
# check-errors: true
# Adapted from resolver/sig_anon_block.rb and desugar/forwarded_restarg_and_kwrestarg.rb.

class AnonymousForwarding
  extend T::Sig

  sig { params(block: T.proc.returns(Integer)).returns(Integer) }
  def accept_block(&block)
    block.call
  end

  sig { params(kwargs: Integer).void }
  def accept_keywords(**kwargs)
    kwargs.keys
  end

  def accept_all(*values, **kwargs, &block)
    values
    kwargs
    block
  end

  sig { params("&": T.proc.returns(Integer)).void }
  def block(&)
    accept_block(&)
    accept_block(&)
    [1].each { accept_block(&) }
    accept_block(
      & # Forward the anonymous block.
    )
  end

  sig { params("&": T.proc.returns(Integer)).void }
  def another_block(&)
    accept_block(&)
  end

  sig { params("**": Integer).void }
  def keywords(**)
    accept_keywords(**)
    T.unsafe(self).accept_keywords(extra: 1, **)
    T.unsafe(self).accept_keywords(**, extra: 1)
    [1].each { accept_keywords(**) }
    T.unsafe(self).accept_keywords(
      extra: 1,
      ** # Forward the anonymous keywords.
    )
  end

  sig { params("*": Integer).void }
  def positional(*)
    T.unsafe(self).accept_all(*)
    T.unsafe(self).accept_all("* ** & ...", *)
    [1].each { T.unsafe(self).accept_all(*) }
    T.unsafe(self).accept_all(
      "* ** & ...", # These are not forwarding tokens.
      *
    )
  end

  sig { params("*": Integer, "**": Integer, "&": T.proc.returns(Integer)).void }
  def combined(*, **, &)
    T.unsafe(self).accept_all(*, **, &)
    T.unsafe(self).accept_all(
      *,
      **,
      &
    )
  end

  def forwarding(...)
    accept_all(...)
    T.unsafe(self).accept_all("...", ...)
    [1].each { accept_all(...) }
    T.unsafe(self).accept_all(
      "* ** & ...", # These are not forwarding tokens.
      ...
    )
  end

  def another_forwarding(...)
    accept_all(...)
  end

  def unused(*, **, &)
  end

  def no_keywords(**nil)
  end

  def named(*values, **kwargs, &block)
    T.unsafe(self).accept_all(*values, **kwargs, &block)
  end
end
