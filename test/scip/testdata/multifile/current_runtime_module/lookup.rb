# typed: true
# check-errors: true

module T
  module Helpers
    def self.runtime_module
      Module
    end

    def self.root_module
      ::Module.new
    end
  end
end
