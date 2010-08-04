ARGV.unshift "server"

root = File.expand_path("../../../../config", __FILE__)
APP_PATH = File.exist?("#{root}/application.rb") ? "#{root}/application.rb" : "#{root}/environment.rb"

require "rails/commands"
