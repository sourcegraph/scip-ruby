# typed: true

class A
  include Singleton
end

# Singleton supports inheritance, turning the sub-class into a singleton as well.
class B < A; end

class C
  include Singleton
  extend T::Helpers
  final!
end

def f
  return [A.instance, B.instance, C.instance]
end
