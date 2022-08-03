# typed: true
# options: showDocs

X = 'X'.freeze
Y = 'Y'.freeze
A = %w[X Y].freeze
B = %W[#{X} Y].freeze

module M
  Z = 'Z'.freeze
  A = %w[X Y Z].freeze
  B = %W[#{X} Y Z].freeze
end
