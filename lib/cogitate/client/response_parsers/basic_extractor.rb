require 'json'

module Cogitate
  module Client
    module ResponseParsers
      # Responsible for parsing a Cogitate response and just getting the basic data
      module BasicExtractor
        def self.call(response:)
          JSON.parse(response).fetch('data')
        end
      end
    end
  end
end
