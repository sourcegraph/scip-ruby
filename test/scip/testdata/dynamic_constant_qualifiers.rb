# typed: true

module Helpers
  Dynamic = build_helpers

  class Client
    include Dynamic
  end

  module Static
  end

  class OtherClient
    include Helpers::Static
  end
end
