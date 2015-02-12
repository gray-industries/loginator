#! /usr/bin/env rake
require 'bundler/gem_tasks'
require 'yard'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: :build

# If there are test failures, you'll need to write code to address them.
# So no point in continuing to run the style tests.
desc 'Runs all spec tests'
RSpec::Core::RakeTask.new(:spec)

desc 'Runs yard'
YARD::Rake::YardocTask.new(:yard)

desc 'runs Rubocop'
RuboCop::RakeTask.new

desc 'Runs test and code cleanliness suite: RuboCop, rspec, and yard'
task run_guards: [:spec, :yard, :rubocop]

task build: :run_guards
