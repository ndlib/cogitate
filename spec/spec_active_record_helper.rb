# This helper provides at least a x4 speed increase over the 'spec_slow_helper'.
require 'active_record'
require 'spec_fast_helper'

unless defined?(Rails)
  database_config = Psych.load_file(File.expand_path('../../config/database.yml', __FILE__))
  ActiveRecord::Base.establish_connection(database_config.fetch('test'))
  Time.zone ||= 'UTC'
end

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      fail ActiveRecord::Rollback
    end
  end
end
