# typed: true
# check-errors: true

module T
  module Module
    def self.marker; end
  end

  module Helpers
    def self.project_module
      Module.marker
    end
  end
end
