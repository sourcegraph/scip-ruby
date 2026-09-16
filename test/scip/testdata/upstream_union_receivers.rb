# typed: true
# Adapted from test/testdata/lsp/rename/method_union_2.rb and method_union_types.rb.

class Dog
  def sound; "Bark"; end
end

class Cat
  def sound; "Meow"; end
end

class Puppy < Dog; end

extend T::Sig

sig { params(animal: T.any(Dog, Cat)).void }
def union_receiver(animal)
  animal.sound
  animal.inspect
end

sig { params(dog: T.any(Dog, Puppy)).void }
def shared_method(dog)
  dog.sound
end
