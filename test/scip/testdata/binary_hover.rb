# typed: true
# options: showDocs

class BinaryHover
  extend T::Sig

  sig { void }
  def self.values
    text = "\xff"
    puts text
    text = "\xc3("
    puts text
    text = "café 日本語 😀"
    puts text
    binary_symbol = :"\xff"
    puts binary_symbol
    bytes = ["\xff", "é"]
    puts bytes
  end
end

BinaryHover.values
