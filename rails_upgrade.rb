$:.push File.expand_path("..", __FILE__)
require "rubygems"
require "rails/all"
require "active_support/all"

require "rails_upgrade/application"
require "rails_upgrade/action_controller"
require "rails_upgrade/active_record"
require "rails_upgrade/action_view"

# This is needed because Rails 3 requires development.rb, while Rails 2.3
# invoked it in a special scope
def self.config
  Rails.application.config
end

module Kernel
  def returning(value)
    yield value
    value
  end
end

module Rails
  module VERSION
    class VersionFaker < ActiveSupport::BasicObject
      def initialize(real_value, pretend_value)
        @real_value, @pretend_value = real_value, pretend_value
      end

      def >=(other)
        @pretend_value >= other
      end

      def >(other)
        @pretend_value > other
      end

      def <=(other)
        @pretend_value <= other
      end

      def <(other)
        @pretend_value < other
      end

      def method_missing(meth, *args, &block)
        @real_value.send(meth, *args, &block)
      end
    end

    MAJOR = VersionFaker.new(MAJOR, 2)
    MINOR = VersionFaker.new(MINOR, 3)
    TINY  = VersionFaker.new(TINY,  5)
  end

  module Initializer
    def self.run(&block)
      klass = Class.new(Rails::Application)
      klass.instance_exec(klass.config, &block)
      klass.config.autoload_paths << klass.root.join("lib")
      Object.const_set(:RAILS_ROOT, klass.root.to_s)
      klass.initialize!
    end
  end

  class Boot
    def self.inherited(klass)
      Rails.module_eval do
        def self.boot!
        end
      end
    end
  end
end
