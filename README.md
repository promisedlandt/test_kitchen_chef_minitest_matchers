# TestKitchenChefMinitestMatchers

Minitest assertions / matchers for testing Chef in Test Kitchen.

# Platforms

Tested on Linux, should work on Windows, but is untested.  
Chef-client needs to be installed to the default location for either platform.

# Installation

Add to your Gemfile under test/integration/<stuite>/minitest/Gemfile:

```ruby
gem "test_kitchen_chef_minitest_matchers"
```

Then, in your tests, add:

```ruby
require "test_kitchen_chef_minitest_matchers"
```

# Chef gem installations

Check whether a gem was successfully installed for the embedded Chef Ruby, for example using the `chef_gem` resource.

Adds `assert_chef_gem_installed` and `refute_chef_gem_installed`.

```ruby
# Let's check whether the PostgreSQL gem is installed
assert_chef_gem_installed "pg"

# We can check for a specific version
assert_chef_gem_installed "pg", "0.18.2"

# Or we can use the gem version constraints, including the pessimistic constraint
assert_chef_gem_installed "pg", "~> 0.18"

# The MySQL gem should not be installed
refute_chef_gem_installed "mysql2"

# While the PostgreSQL gem should be installed, no 0.17.x version should be installed
refute_chef_gem_installed "pg", "~> 0.17"
```

For fans of the spec syntax, `.must_be_installed_as_chef_gem` and `.must_not_be_installed_as_chef_gem` are added.

```ruby
# Let's check whether the PostgreSQL gem is installed
"pg".must_be_installed_as_chef_gem

# We can check for a specific version
"pg".must_be_installed_as_chef_gem("0.18.2")

# Or we can use the gem version constraints, including the pessimistic constraint
"pg".must_be_installed_as_chef_gem("~> 0.18")

# The MySQL gem should not be installed
"mysql2".must_not_be_installed_as_chef_gem

# While the PostgreSQL gem should be installed, no 0.17.x version should be installed
"pg".must_not_be_installed_as_chef_gem("~> 0.17")
```
