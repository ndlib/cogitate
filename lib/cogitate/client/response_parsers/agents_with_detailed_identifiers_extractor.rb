require 'json'
require 'cogitate/client/data_to_object_coercer'

module Cogitate
  module Client
    module ResponseParsers
      # Responsible for parsing a Cogitate response and just getting the basic data
      module AgentsWithDetailedIdentifiersExtractor
        def self.call(response:)
          JSON.parse(response).fetch('data').map { |datum| DataToObjectCoercer.call(datum) }
        end
      end
    end
  end
end
