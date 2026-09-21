# typed: true
# options: showDocs

extend T::Sig

sig { params(part: String).void }
def literal_receiver(part)
  plain = String.new
  plain << part
  literal = +""
  literal << part
  "literal".upcase
  :name.to_s
  42.abs
  1.5.floor
end
