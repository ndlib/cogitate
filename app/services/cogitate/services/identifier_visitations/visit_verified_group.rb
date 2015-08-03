require 'cogitate/interfaces'
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

        # REVIEW: Extract to a more appropriate container?
        GROUP_STRATEGY = 'group'.freeze

        # @api private
        # @see Cogitate::Serivces::IdentifierVisitations::VisitVerifiedGroup.call
        Contract(
          Contracts::KeywordArgs[
            group_member_identifier: Cogitate::Interfaces::IdentifierInterface, guest: Cogitate::Interfaces::VisitorInterface
          ] => Contracts::RespondTo[:call]
        )
        def initialize(group_member_identifier:, guest:, repository: default_repository)
          self.group_member_identifier = group_member_identifier
          self.guest = guest
          self.repository = repository
          initialize_group_identifier_enumerator!
          self
        end

        # @api public
        def call
          group_identifier_enumerator.each do |group_identifier|
            guest.visit(group_identifier) do |visitor|
              receive(visitor: visitor, group_identifier: group_identifier)
            end
          end
          nil
        end

        private

        attr_accessor :group_member_identifier, :guest, :repository

        def receive(visitor:, group_identifier:)
          visitor.add_identity(group_identifier)
          visitor.add_verified_authentication_vector(group_identifier)
        end

        def initialize_group_identifier_enumerator!
          @group_identifier_enumerator = repository.each_identifier_related_to(
            identifier: group_member_identifier, strategy: GROUP_STRATEGY
          )
        end

        attr_reader :group_identifier_enumerator

        def default_repository
          RepositoryService::IdentifierRelationship
        end
      end
    end
  end
end