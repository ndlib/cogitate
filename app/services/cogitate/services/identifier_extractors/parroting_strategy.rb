require 'contracts'
require 'cogitate/interfaces'

module Cogitate
  module Services
    module IdentifierExtractors
      # This class is in place to say "You said you had this identifier, so I'll add it as an identity though I don't know much about it."
      # @api public
      class ParrotingStrategy
        extend Contracts

        Contract(
          Contracts::KeywordArgs[
            identifier: Cogitate::Interfaces::IdentifierInterface,
            membership_visitation_service: Cogitate::Interfaces::MembershipVisitationStrategyInterface
          ] => Cogitate::Interfaces::HostInterface
        )
        # @api public
        def self.call(identifier:, **)
          new(identifier: identifier)
        end

        # Instantiate a ParrotingStrategy for visitation
        #
        # @param identifier [Cogitate::Interfaces::IdentifierInterface]
        # @param identifier_builder [#call(identifier:)] I want make sure that I have an unverified identifier
        #
        # @todo What if we already have a Identifier::Unverified?
        def initialize(identifier:, identifier_builder: default_identifier_builder)
          self.identifier = identifier_builder.call(identifier: identifier)
        end

        # @api public
        def invite(guest)
          guest.visit(identifier) { |visitor| visitor.add_identifier(identifier) }
        end

        private

        attr_accessor :identifier

        def default_identifier_builder
          require 'cogitate/models/identifier/unverified' unless defined?(Models::Identifier::Unverified)
          Models::Identifier::Unverified.method(:new)
        end
      end
    end
  end
end
