require "test_helper"

describe TestKitchenChefMinitestMatchers::ChefGem do
  TEST_GEM_NAME = "test_gem"

  describe ".must_be_installed_as_chef_gem" do
    before do
      @installed_gem_versions = ["1.2.3", "2.0.1"]

      fake_install_chef_gems(TEST_GEM_NAME => @installed_gem_versions)
    end

    it "finds an installed gem" do
      TEST_GEM_NAME.must_be_installed_as_chef_gem
    end

    it "finds an installed gem with a specific version" do
      TEST_GEM_NAME.must_be_installed_as_chef_gem(@installed_gem_versions.first)
    end

    it "finds an installed gem with a pessimistic version constraint" do
      TEST_GEM_NAME.must_be_installed_as_chef_gem("~> #{ @installed_gem_versions.first.split(".").take(2).join(".") }")
    end
  end

  describe ".must_not_be_installed_as_chef_gem" do
    it "does not find a non installed gem" do
      TEST_GEM_NAME.must_not_be_installed_as_chef_gem
    end

    it "finds no installed gem outside a pessimistic version constraint" do
      fake_install_chef_gems(TEST_GEM_NAME => ["1.2.3", "2.0.1"])

      TEST_GEM_NAME.must_not_be_installed_as_chef_gem("~> 0")
    end
  end

  describe ".assert_chef_gem_installed" do
    before do
      @installed_gem_versions = ["1.2.3", "2.0.1"]

      fake_install_chef_gems(TEST_GEM_NAME => @installed_gem_versions)
    end

    it "finds an installed gem" do
      assert_chef_gem_installed(TEST_GEM_NAME)
    end

    it "finds an installed gem with a specific version" do
      assert_chef_gem_installed(TEST_GEM_NAME, @installed_gem_versions.first)
    end

    it "finds an installed gem with a pessimistic version constraint" do
      assert_chef_gem_installed(TEST_GEM_NAME, "~> #{ @installed_gem_versions.first.split(".").take(2).join(".") }")
    end
  end

  describe ".refute_chef_gem_installed" do
    it "does not find a non installed gem" do
      fake_install_chef_gems("another_gem" => ["1.0.0"])

      refute_chef_gem_installed(TEST_GEM_NAME)
    end

    it "finds no installed gem outside a pessimistic version constraint" do
      fake_install_chef_gems(TEST_GEM_NAME => ["1.2.3", "2.0.1"])

      refute_chef_gem_installed(TEST_GEM_NAME, "~> 0")
    end
  end

  describe ".chef_gem_installed?" do
    before do
      @installed_gem_versions = ["1.2.3", "2.0.1"]

      fake_install_chef_gems(TEST_GEM_NAME => @installed_gem_versions)
    end

    describe "finding the gem" do
      it "returns true for an installed gem without version information" do
        assert TestKitchenChefMinitestMatchers::ChefGem.chef_gem_installed?(TEST_GEM_NAME)
      end

      it "returns true for an installed gem with the exact version information" do
        assert TestKitchenChefMinitestMatchers::ChefGem.chef_gem_installed?(TEST_GEM_NAME, @installed_gem_versions.first)
      end

      it "returns true for an installed gem with a pessimistic version constraint" do
        assert TestKitchenChefMinitestMatchers::ChefGem.chef_gem_installed?(TEST_GEM_NAME, "~> #{ @installed_gem_versions.first.split(".").take(2).join(".") }")
      end

      it "returns true for an installed gem with a less-than version constraint" do
        assert TestKitchenChefMinitestMatchers::ChefGem.chef_gem_installed?(TEST_GEM_NAME, "< #{ [@installed_gem_versions.first.split(".").first.to_i + 1, 0, 0].join(".") }")
      end

      it "returns true for an installed gem with a less-or-equal-than version constraint" do
        assert TestKitchenChefMinitestMatchers::ChefGem.chef_gem_installed?(TEST_GEM_NAME, "<= #{ @installed_gem_versions.first }")
      end

      it "returns true for an installed gem with a greater-than version constraint" do
        assert TestKitchenChefMinitestMatchers::ChefGem.chef_gem_installed?(TEST_GEM_NAME, "> #{ [@installed_gem_versions.first.split(".").first.to_i - 1, 0, 0].join(".") }")
      end

      it "returns true for an installed gem with a greater-or-equal-than version constraint" do
        assert TestKitchenChefMinitestMatchers::ChefGem.chef_gem_installed?(TEST_GEM_NAME, ">= #{ @installed_gem_versions.first }")
      end
    end

    describe "not finding the gem" do
      it "returns false for a not installed gem" do
        refute TestKitchenChefMinitestMatchers::ChefGem.chef_gem_installed?(TEST_GEM_NAME + "asdf")
      end

      it "returns false for an installed gem outside the pessimistic version constraint" do
        refute TestKitchenChefMinitestMatchers::ChefGem.chef_gem_installed?(TEST_GEM_NAME, "~> 0")
      end
    end
  end

  describe ".installed_chef_gem_versions" do
    it "finds a single installed version" do
      installed_gem_versions = ["1.2.3"]

      fake_install_chef_gems(TEST_GEM_NAME => installed_gem_versions)

      assert_equal installed_gem_versions, TestKitchenChefMinitestMatchers::ChefGem.installed_chef_gem_versions(TEST_GEM_NAME)
    end

    it "finds multiple installed versions" do
      installed_gem_versions = ["1.2.3", "1.2.4", "2.3.7"]

      fake_install_chef_gems(TEST_GEM_NAME => installed_gem_versions)

      assert_equal installed_gem_versions, TestKitchenChefMinitestMatchers::ChefGem.installed_chef_gem_versions(TEST_GEM_NAME)
    end

    it "matches the exact name" do
      installed_gem_versions = ["1.2.3"]

      fake_install_chef_gems(TEST_GEM_NAME => installed_gem_versions,
                             "#{ TEST_GEM_NAME }-rails" => "1.2.2",
                             "#{ TEST_GEM_NAME }improved" => "1.2.1",
                             "better#{ TEST_GEM_NAME }" => "1.3.1")

      assert_equal installed_gem_versions, TestKitchenChefMinitestMatchers::ChefGem.installed_chef_gem_versions(TEST_GEM_NAME)
    end

    it "returns an empty array when no version is installed" do
      fake_install_chef_gems("another_gem" => "1.0.0")

      assert_empty TestKitchenChefMinitestMatchers::ChefGem.installed_chef_gem_versions(TEST_GEM_NAME)
    end
  end
end
