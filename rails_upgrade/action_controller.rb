require "action_controller"
require "action_controller/base"

module ActionController
  def self.const_missing(const)
    if const == :UrlWriter
      const_set(:UrlWriter, Rails.application.routes.url_helpers)
    else
      super
    end
  end

  class Base
    module ExtendedDeprecation
      def session=(value)
        super
        if secret = value[:secret]
          Rails.application.config.secret_token = secret
        end
      end
    end

    extend ExtendedDeprecation
  end
end
