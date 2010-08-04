require "action_view"
require "action_view/base"

module ActiveSupport
  remove_const :SafeBuffer
  class SafeBuffer < String
    alias safe_concat concat
  end
end



module ActionView
  module Helpers
    module ActiveRecordHelper
      def self.included(klass)
        klass.class_eval { include ActiveModelHelper }
      end
    end

    module AssetTagHelper
      def self.reset_javascript_include_default
        self.javascript_expansions[:default] = ['prototype', 'effects', 'dragdrop', 'controls', 'rails']
      end
    end

    module UrlHelper
      def _routes
        Rails.application.routes
      end

      # hack because Rails 3 UrlHelper requires #controller, while in Rails 2 it just required @controller
      def controller
        @controller
      end
    end
  end

  class Base
    # change the default behavior for tag and content_tag to not escape
    module DeactivateEscape
      def tag(name, options = nil, open = false, escape = false)
        super
      end

      def content_tag(name, content_or_options_with_block = nil, options = nil, escape = false, &block)
        super
      end

      def content_tag_string(name, content, options, escape = false)
        super
      end
    end

    include DeactivateEscape
  end
end
