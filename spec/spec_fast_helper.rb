# This helper provides at least a ~x3 speed increase over the 'spec_slow_helper'.
require 'rspec/core'
require 'rspec/its'
require 'support/matchers'
unless defined?(Rails) # If we are in a Rails context this is overkill.
  Dir[File.expand_path('../../app/*', __FILE__)].each do |dir|
    $LOAD_PATH << dir
  end
  $LOAD_PATH << File.expand_path('../../lib', __FILE__)

  unless defined?(require_dependency)
    def require_dependency(*files)
      require(*files)
    end
  end
end

# A helper class for dealing with Fixtures
class FixtureFile < SimpleDelegator
  def self.path_for(slug)
    File.expand_path("../fixtures/#{slug}", __FILE__)
  end

  # @example FixtureFile.open('hello.rb', w+) { |f| f.puts '# Content' }
  def self.method_missing(method_name, slug, *args, &block)
    File.public_send(method_name, path_for(slug), *args, &block)
  end

  def initialize(slug, *args, &block)
    super(File.new(self.class.path_for(slug), *args, &block))
  end
end
