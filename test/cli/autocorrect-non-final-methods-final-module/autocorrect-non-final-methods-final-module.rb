# typed: true

class FinalClass
  extend T::Sig
  extend T::Helpers

  final!

  sig {returns(T.untyped)}
  def needs_autocorrect; end
  def no_sig_suggestion1; end

  sig {returns(T.untyped)}
  def needs_autocorrect_multiline
    nil
  end
  def no_sig_suggestion2; end

  sig do
    returns(T.untyped)
  end
  def needs_autocorrect_multiline_sig; end
  def no_sig_suggestion3; end

  sig do
    returns(T.untyped)
  end
  def needs_autocorrect_multiline_multiline_sig
    nil
  end
  def no_sig_suggestion4; end

  def no_sig_suggestion_multiline
    nil
  end

  attr_reader :no_sig_attr

  sig {returns(T.untyped)}
  attr_reader :sig_attr
  def no_sig_suggestion5; end

  sig {params(sig_writer: T.untyped).returns(T.untyped)}
  attr_writer :sig_writer
  def no_sig_suggestion6; end

  sig {returns(T.untyped)}
  attr_accessor :sig_accessor
  def no_sig_suggestion7; end

  sig {returns(T.untyped)}
  attr_reader :sig_attr_multi1, :sig_attr_multi2
  def no_sig_suggestion8; end

  sig(:final) {returns T.untyped}
  attr_reader :sig_attr_final1
  def no_sig_suggestion9; end

  sig(:final) do
    returns T.untyped
  end
  attr_reader :sig_attr_final2
  def no_sig_suggestion10; end
end
