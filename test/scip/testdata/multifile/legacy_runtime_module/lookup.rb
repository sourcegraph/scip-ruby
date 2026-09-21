# typed: true
# check-errors: true

module T
  module Helpers
    # Old Tapioca expects the root Module in both locations.
    prepend(Module.new do
      def legacy_runtime_helper; end
    end)
    NAME_METHOD = T.let(Module.instance_method(:name), UnboundMethod)

    def self.explicit_runtime_module
      # Explicit qualification keeps the requested namespace.
      T::Module
    end

    def self.root_module
      ::Module
    end
  end
end
