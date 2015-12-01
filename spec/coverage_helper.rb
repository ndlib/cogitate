## Generation Notes:
##   This file was generated via the commitment:install generator. You are free
##   and expected to change this file.
if ENV['COV'] || ENV['COVERAGE'] || ENV['TRAVIS']
  if ENV['TRAVIS']
    require 'simplecov'
    require "codeclimate-test-reporter"
    ENV['CODECLIMATE_REPO_TOKEN'] ||= 'c639f505c78fb873db0cc567133b8529fa26401a65ba82f11311ab9937ee0fdf'
    CodeClimate::TestReporter.start do
      formatter(SimpleCov::Formatter::MultiFormatter.new([
        SimpleCov::Formatter::HTMLFormatter,
        CodeClimate::TestReporter::Formatter
      ]))
      load_profile 'rails'
    end
  elsif ENV['COV'] || ENV['COVERAGE']
    require 'simplecov'
    SimpleCov.start { load_profile 'rails' }
  end
end
