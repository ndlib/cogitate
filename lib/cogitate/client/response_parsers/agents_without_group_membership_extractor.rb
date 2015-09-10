require 'json'
require 'cogitate/client/data_to_object_coercer'
require 'cogitate/models/identifier'

module Cogitate
  module Client
    module ResponseParsers
      # When you want an agent that omits identifiers associated with a group
      module AgentsWithoutGroupMembershipExtractor
        def self.call(response:)
          identifier_guard = method(:identifier_is_not_a_group?)
          JSON.parse(response).fetch('data').map { |datum| DataToObjectCoercer.call(datum, identifier_guard: identifier_guard) }
        end

        # @api private
        # Perhaps a weird place to put this code, but it appears to work
        def self.identifier_is_not_a_group?(identifier:)
          identifier.strategy != Cogitate::Models::Identifier::GROUP_STRATEGY_NAME
        end
      end
    end
  end
end
