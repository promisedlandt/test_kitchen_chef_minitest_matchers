module Minitest
  module Assertions
    def assert_chef_gem_installed(gem_name, version_requirements = nil, options = {})
      if options[:msg]
        message = options[:msg]
      else
        message = "Expected #{ gem_name } to be installed but it is not"
        message += ", version requirements: #{ version_requirements }" if version_requirements
      end

      assert TestKitchenChefMinitestMatchers::ChefGem.chef_gem_installed?(gem_name, version_requirements), message
    end

    def refute_chef_gem_installed(gem_name, version_requirements = nil, options = {})
      if options[:msg]
        message = options[:msg]
      else
        message = "Expected #{ gem_name } not to be installed but it is"
        message += ", version requirements: #{ version_requirements }" if version_requirements
      end

      refute TestKitchenChefMinitestMatchers::ChefGem.chef_gem_installed?(gem_name, version_requirements), message
    end
  end
end

[String, Symbol].each do |klass|
  klass.infect_an_assertion :assert_chef_gem_installed, :must_be_installed_as_chef_gem, :reverse
  klass.infect_an_assertion :refute_chef_gem_installed, :must_not_be_installed_as_chef_gem, :reverse
end

module TestKitchenChefMinitestMatchers
  class ChefGem
    class << self
      def chef_gem_installed?(gem_name, *version_requirements)
        installed_versions = installed_chef_gem_versions(gem_name)

        return false if installed_versions.empty?

        gem_dependency = Gem::Dependency.new("", version_requirements)

        installed_versions.any? { |installed_version| gem_dependency.match?("", installed_version) }
      end

      def installed_chef_gem_versions(gem_name)
        # test-kitchen sets GEM_HOME, GEM_PATH and GEM_CACHE for its own testing gems
        cmd_string = %((unset GEM_HOME; unset GEM_PATH; unset GEM_CACHE; #{ chef_gem_path } list --versions --local --no-details #{ gem_name }))
        cmd = Mixlib::ShellOut.new(cmd_string)
        cmd.run_command

        line_regexp = /^#{ gem_name } \((.*)\)/

        matching_line = cmd.stdout.lines.detect { |line| line_regexp.match(line) }

        return [] unless matching_line

        match_data = line_regexp.match(matching_line)

        match_data[1].split(", ")
      end

      private

      def chef_gem_path
        @chef_gem_path ||= if RbConfig::CONFIG["host_os"] =~ /mswin|mingw/
                             "C:\\opscode\\chef\\embedded\\bin"
                           else
                             "/opt/chef/embedded/bin/gem"
                           end
      end
    end
  end
end
