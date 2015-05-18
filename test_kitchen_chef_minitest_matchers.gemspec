# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "test_kitchen_chef_minitest_matchers/version"

Gem::Specification.new do |spec|
  spec.name          = "test_kitchen_chef_minitest_matchers"
  spec.version       = TestKitchenChefMinitestMatchers::VERSION
  spec.authors       = ["Nils Landt"]
  spec.email         = ["nils@promisedlandt.de"]
  spec.summary       = %q{Minitest-Matchers for testing Chef in Test Kitchen}
  spec.homepage      = "https://github.com/promisedlandt/test_kitchen_chef_minitest_matchers"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mixlib-shellout", "~> 2"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest-focus", "~> 1"
  spec.add_development_dependency "mocha", "~> 1"
  spec.add_development_dependency "byebug", "~> 4"
  spec.add_development_dependency "rubocop", "~> 0"
  spec.add_development_dependency "guard", "~> 2"
  spec.add_development_dependency "guard-minitest", "~> 2"
end
