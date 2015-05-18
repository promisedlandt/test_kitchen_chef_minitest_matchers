# Specified in Gemfile
require "mixlib/shellout"

# Internal stuff
require "test_kitchen_chef_minitest_matchers/version"
require "test_kitchen_chef_minitest_matchers/chef_gem"

# rubocop:disable HandleExceptions
# Development stuff, can't be loaded in production, but that's fine
%w(byebug).each do |development_gem|
  begin
    require development_gem
  rescue LoadError
  end
end
# rubocop:enable HandleExceptions

# @author Nils Landt
module TestKitchenChefMinitestMatchers
end
