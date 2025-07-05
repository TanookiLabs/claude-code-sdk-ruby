# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "yard"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new
YARD::Rake::YardocTask.new

task default: %i[spec rubocop]

desc "Run tests with coverage"
task :coverage do
  ENV["COVERAGE"] = "true"
  Rake::Task["spec"].invoke
end

desc "Open an IRB session with the gem loaded"
task :console do
  require "irb"
  require "claude_code_sdk"
  ARGV.clear
  IRB.start
end

desc "Run integration tests (requires Claude Code CLI)"
task :integration do
  ENV["INTEGRATION"] = "true"
  Rake::Task["spec"].invoke
end
