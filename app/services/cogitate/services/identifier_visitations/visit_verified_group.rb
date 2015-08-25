require 'cogitate/interfaces'
require 'cogitate/models/identifier'
module Cogitate
  module Services
    module IdentifierVisitations
      # Responsible for coordinating a visit to all groups associated with the given identifier.
      class VisitVerifiedGroup
        include Contracts

        # @api public
        def self.call(identifier:, visitor:, **keywords)
          new(group_member_identifier: identifier, guest: visitor, **keywords).call
        end

        # @api private
        # @see Cogitate::Serivces::IdentifierVisitations::VisitVerifiedGroup.call
        Contract(
          Contracts::KeywordArgs[
            group_member_identifier: Cogitate::Interfaces::IdentifierInterface,
            guest: Cogitate::Interfaces::VisitorInterface,
            repository: Optional[RespondTo[:with_verified_group_identifier_related_to]]
          ] => Contracts::RespondTo[:call]
        )
        def initialize(group_member_identifier:, guest:, repository: default_repository)
          self.group_member_identifier = group_member_identifier
          self.guest = guest
          self.repository = repository
          initialize_related_verified_group_identifiers!
          self
        end

        # @api public
        def call
          visit_explicitly_related_verified_group_identifiers
          visit_implicitly_related_verified_group_identifiers
          nil
        end

        private

        def visit_explicitly_related_verified_group_identifiers
          related_verified_group_identifiers.each do |group_identifier|
            receive(group_identifier: group_identifier)
          end
        end

        def visit_implicitly_related_verified_group_identifiers
          receive(group_identifier: implicit_group_identifier)
        end

        def implicit_group_identifier
          Cogitate::Models::Identifier.new_for_implicit_verified_group_by_strategy(strategy: group_member_identifier.strategy)
        end

        attr_accessor :group_member_identifier, :guest, :repository

        def receive(group_identifier:)
          guest.visit(group_identifier) do |visitor|
            visitor.add_identifier(group_identifier)
            visitor.add_verified_identifier(group_identifier)
          end
        end

        def initialize_related_verified_group_identifiers!
          @related_verified_group_identifiers = repository.with_verified_group_identifier_related_to(identifier: group_member_identifier)
        end

        attr_reader :related_verified_group_identifiers

        def default_repository
          require 'cogitate/query_repository' unless defined?(Cogitate::QueryRepository)
          Cogitate::QueryRepository.new
        end
      end
    end
  end
end
