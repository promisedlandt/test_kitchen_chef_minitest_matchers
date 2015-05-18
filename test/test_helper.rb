require "bundler/setup"

require "minitest/autorun"
require "minitest/focus"
require "mocha/setup"

require "test_kitchen_chef_minitest_matchers"

def fake_install_chef_gems(installed_gems)
  shellout = mocked_shellout(stdout: gem_list_output(installed_gems))
  Mixlib::ShellOut.stubs(:new).returns(shellout)
  shellout.expects(:run_command)
end

def gem_list_output(installed_gems)
  result = ["", "*** LOCAL GEMS ***", ""]

  installed_gems.each_with_object(result) do |(gem_name, installed_versions), collection|
    collection << "#{ gem_name } (#{ Array(installed_versions).join(", ") })"
  end

  result.join("\n")
end

def mocked_shellout(stdout: "", stderr: "", error: false, exitstatus: 0)
  result = mock.stubs(:run_command)

  if error
    result.stubs(:error!).raises(Mixlib::ShellOut::ShellCommandFailed)
  else
    result.stubs(:error!).returns(false)
  end

  result.stubs(:stderr).returns(stderr)
  result.stubs(:stdout).returns(stdout)
  result.stubs(:exitstatus).returns(exitstatus)

  result
end
