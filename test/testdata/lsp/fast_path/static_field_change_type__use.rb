# typed: strict
extend T::Sig

sig {returns(String)}
def foo
  A.fetch(:key, "default") + "suffix"
end
