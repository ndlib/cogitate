# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'commitment/railtie'

Rails.application.load_tasks

# BEGIN `commitment:install` generator
# This was added via commitment:install generator. You are free to change this.
Rake::Task["default"].clear
task(
  default: [
    'commitment:rubocop',
    'commitment:jshint',
    'commitment:scss_lint',
    'commitment:configure_test_for_code_coverage',
    'spec',
    'commitment:code_coverage',
    'commitment:brakeman'
  ]
)
# END `commitment:install` generator

namespace :spec do
  desc 'Run the Travis CI specs'
  task travis: ['db:create', 'db:schema:load', :default]
end
