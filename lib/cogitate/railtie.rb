require 'rails/railtie'

module Cogitate
  # Responsible for exposing features (generators, rake tasks, etc) to a Rails
  # application that leverages Cogitate.
  class Railtie < Rails::Railtie
    generators do
      require 'cogitate/generators/install_generator'
    end
  end
end
