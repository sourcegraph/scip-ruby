# typed: true

class Opus::Base
end

class Opus::Derived < Opus::Base
end

TYPES = T.let({ derived: -> { Opus::Derived } }, T::Hash[Symbol, T.proc.returns(T.class_of(Opus::Base))])

module ABC
  TYPES_IN_MODULE = T.let({ derived: -> { Opus::Derived } }, T::Hash[Symbol, T.proc.returns(T.class_of(Opus::Base))])
end

class Other
  TYPES_IN_CLASS = T.let({ derived: -> { Opus::Derived } }, T::Hash[Symbol, T.proc.returns(T.class_of(Opus::Base))])
end
