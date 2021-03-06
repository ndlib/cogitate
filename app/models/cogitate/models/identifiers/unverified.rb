require 'forwardable'
require 'cogitate/interfaces'
require 'cogitate/models/identifier'

module Cogitate
  module Models
    module Identifiers
      # An identifier that has not been verified via some mechanism.
      class Unverified
        include Contracts
        Contract(
          Contracts::KeywordArgs[identifier: Cogitate::Interfaces::IdentifierInterface] =>
          Cogitate::Interfaces::VerifiableIdentifierInterface
        )
        def initialize(identifier:)
          self.identifier = identifier
          self
        end

        def verified?
          false
        end

        def as_json(*)
          { 'identifying_value' => identifying_value, 'strategy' => strategy }
        end

        extend Forwardable
        include Comparable
        def_delegators :identifier, *Cogitate::Models::Identifier.interface_method_names

        private

        attr_accessor :identifier
      end
    end
  end
end
