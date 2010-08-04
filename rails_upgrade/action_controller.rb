require "action_dispatch"

module ActionController
  module Assertions
    def self.const_missing(constant)
      ActionDispatch::Assertions.const_get(constant)
    end
  end
end
