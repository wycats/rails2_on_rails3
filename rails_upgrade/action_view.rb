require "action_view"
require "action_view/base"

module ActiveSupport
  remove_const :SafeBuffer
  class SafeBuffer < String
    alias safe_concat concat
  end
end



module ActionView
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
