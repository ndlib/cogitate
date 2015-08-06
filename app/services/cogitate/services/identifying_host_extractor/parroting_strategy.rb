require 'contracts'
require 'cogitate/interfaces'

module Cogitate
  module Services
    module IdentifyingHostExtractor
      # This class is in place to say "You said you had this identifier, so I'll add it as an identity though I don't know much about it."
      # @api public
      class ParrotingStrategy
        extend Contracts

        # @api public
        Contract(Contracts::KeywordArgs[identifier: Cogitate::Interfaces::IdentifierInterface] => Cogitate::Interfaces::HostInterface)
        def self.call(identifier:)
          new(identifier: identifier)
        end

        # @param identifier [Cogitate::Interfaces::IdentifierInterface]
        # @param identifier_builder [#call(identifier:)] I want make sure that I have an unverified identifier
        #
        # @todo What if we already have a Identifier::Unverified
        def initialize(identifier:, identifier_builder: default_identifier_builder)
          self.identifier = identifier_builder.call(identifier: identifier)
        end

        def invite(guest)
          guest.visit(identifier) { |visitor| visitor.add_identifier(identifier) }
        end

        private

        attr_accessor :identifier

        def default_identifier_builder
          require 'identifier/unverified' unless defined?(Identifier::Unverified)
          Identifier::Unverified.method(:new)
        end
      end
    end
  end
end
