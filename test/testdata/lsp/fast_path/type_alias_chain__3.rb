# typed: true
# spacer for exclude-from-file-update
extend T::Sig

Alias3 = T.type_alias {Alias2}

sig {params(x: Alias3).void}
def example3(x)
  # bug, should change to String
  T.reveal_type(x) # error: `Integer`
end
