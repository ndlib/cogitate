require 'rails/railtie'

module Cogitate
  # :nodoc:
  class Railtie < Rails::Railtie
    generators do
      require 'cogitate/generators/install_generator'
    end
  end
end
