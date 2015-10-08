# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require "bundler/gem_tasks"
begin
  require 'commitment/railtie'
rescue LoadError
  $stderr.puts "Who will honor your commitments?"
  # Just kidding. Its okay because we don't need the commitment tasks in all environments.
end

Rails.application.load_tasks

# Because all of the conditional logic was confusing task definitions.
# On my local machine specs were run once; However on travis without this
# unless statement, specs were run twice.
unless Rake::Task.task_defined?('spec')
  begin
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.pattern = "./spec/**/*_spec.rb"
    end
  rescue LoadError
    $stdout.puts "RSpec failed to load; You won't be able to run tests."
  end
end

Rake::Task["default"].clear if Rake::Task.task_defined?('default')

if defined?(Commitment)
  # BEGIN `commitment:install` generator
  # This was added via commitment:install generator. You are free to change this.
  task(
    default: [
      'commitment:rubocop',
      # 'commitment:jshint',
      # 'commitment:scss_lint',
      'commitment:configure_test_for_code_coverage',
      'spec',
      'commitment:code_coverage',
      'commitment:brakeman'
    ]
  )
  # END `commitment:install` generator
elsif defined?(RSpec)
  task(default: 'spec')
end

namespace :spec do
  desc 'Run the Travis CI specs'
  task travis: ['db:create', 'db:schema:load', :default]
end
