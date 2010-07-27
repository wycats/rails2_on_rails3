ARGV.unshift "server"

APP_PATH = File.expand_path("../../../../config/environment.rb", __FILE__)
$".push File.expand_path("../boot.rb", APP_PATH)

require "rails/commands"
exit!
