require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"
require "yard"

desc "Start guard for minitest"
task :guard do
  sh "guard --no-interactions --notify false --clear"
end

desc "Run rubocop linter"
RuboCop::RakeTask.new(:rubocop) do |task|
  task.formatters = %w(simple)
end

Rake::TestTask.new(:test) do |test|
  test.libs << "lib" << "test"
  test.pattern = "test/**/*_test.rb"
  test.verbose = true
end

desc "for travis-ci run"
task travis: :default

task default: [:test, :rubocop]
