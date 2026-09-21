# typed: true
# Adapted from test/testdata/lsp/hover_ampersand_operations.rb.

class Dog
  extend T::Sig

  sig { returns(String) }
  attr_reader :breed

  sig { params(breed: String).void }
  def initialize(breed)
    @breed = T.let(breed, String)
  end
end

extend T::Sig

sig { params(dogs: T::Array[Dog], maybe_dog: T.nilable(Dog)).void }
def ampersand_calls(dogs, maybe_dog)
  dogs.map(&:breed)
  dogs.map(&:"breed")
  dogs.map(&:'breed')
  dogs.map(&:itself)
  maybe_dog&.breed
  maybe_dog&.breed&.upcase
  breed = T.let(nil, T.nilable(String))
  breed ||= maybe_dog&.breed
  breed &&= maybe_dog&.breed
end

sig { params(dog: Dog).void }
def known_receiver(dog)
  dog&.breed
  (dog)&.breed
  dog.breed&.upcase
  Dog.new("Labrador")&.breed
  nil&.breed
end
