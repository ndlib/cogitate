module Commitment
  # :nodoc:
  class InstallGenerator < Rails::Generators::Base
    source_root(File.expand_path("../templates", __FILE__))

    def create_cogitate_initializer
      template('cogitate_initializer.rb.erb', 'config/initializers/cogitate_initializer.rb')
    end
  end
end
