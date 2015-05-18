guard :minitest do
  watch(%r{^test/(.*)_test\.rb})
  watch("lib/test_kitchen_chef_minitest_matchers.rb") { "test" }
  watch(%r{^lib/test_kitchen_chef_minitest_matchers/(.*/)?([^/]+)\.rb})     { |m| "test/#{ m[1] }#{ m[2] }_test.rb" }
  watch(%r{^test/test_helper\.rb})    { "test" }
end
