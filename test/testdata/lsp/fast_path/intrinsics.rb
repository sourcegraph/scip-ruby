# typed: true

def sample; end
def ===; end
def []; end
def proc; end

T.reveal_type([1, 2, 3].sample) # error: `Integer`
T.reveal_type(Integer.===(0)) # error: `TrueClass`
T.reveal_type(Integer.===('')) # error: `FalseClass`
T.reveal_type(T::Array[T.proc.params(x: Integer).void].new) # error: `T::Array[T.proc.params(arg0: Integer).void]`
