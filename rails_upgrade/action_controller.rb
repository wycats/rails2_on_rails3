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
end
