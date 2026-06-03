# typed: true

# 3+-level constant qualifier walks in class names, ancestors, and references.
# Exercises the recursion in saveQualifierReferences.

module Outer
  module Inner
    module Deep
      class Base
        def m; end
      end

      module Mixin
        def helper
          "h"
        end
      end
    end
  end
end

# 4-level qualifier in class header and in superclass position.
class Outer::Inner::Deep::Derived < Outer::Inner::Deep::Base
end

# Qualified include in an ancestor expression.
class WithDeepMixin
  include Outer::Inner::Deep::Mixin
end

def use_nested
  _ = Outer::Inner::Deep::Base.new
  _ = WithDeepMixin.new.helper
  return
end
