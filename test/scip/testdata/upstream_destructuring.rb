# typed: true
# options: showDocs
# Adapted from test/testdata/lsp/hover_mlhs_assign.rb.

extend T::Sig

sig { returns([Integer, Integer]) }
def returns_tuple = [0, 0]

arg0, arg1 = returns_tuple
puts(arg0, arg1)

sig { returns([Integer, Integer, Integer]) }
def returns_3tuple = [0, 0, 0]

arg0, *arg1 = returns_3tuple
puts(arg0, arg1)

sig { returns(T::Array[String]) }
def returns_string_array = ["a", "b", "c", "d"]

arg0, arg1 = returns_string_array
puts(arg0, arg1)
