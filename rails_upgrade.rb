$:.push File.expand_path("..", __FILE__)
require "rubygems"

gemfile = File.expand_path("../../Gemfile", caller[0].split(":")[0])

gemfile_contents = <<GEMFILE
source 'http://rubygems.org'

gem 'rails', '3.0.0.rc'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
GEMFILE

def require_bundler
  require "bundler/setup"
rescue LoadError
  puts "Please install bundler with `gem install bundler --pre` and then try again"
  exit
end


if File.exist?(gemfile)
  require_bundler
else
  puts "The default Rails Gemfile has been added to your application."
  File.open(gemfile, "w") { |file| file.puts gemfile_contents }
end

require_bundler

require "rails/all"
require "active_support/all"
require "rails_upgrade/action_view"

# This is needed because Rails 3 requires development.rb, while Rails 2.3
# invoked it in a special scope
def self.config
  Rails.application.config
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

    def self.with_version(full_version)
      new = full_version.split(".")
      old = [MAJOR, MINOR, TINY]
      class_eval "MAJOR, MINOR, TINY = #{new.inspect}"
      yield
    ensure
      class_eval "MAJOR, MINOR, TINY = #{old.inspect}"
    end
  end

  module Initializer
    def self.run(&block)
      klass = Class.new(Rails::Application)
      klass.instance_exec(klass.config, &block)
      klass.initialize!
    end
  end
end
