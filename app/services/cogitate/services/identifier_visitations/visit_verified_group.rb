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

        # @api private
        # @see Cogitate::Serivces::IdentifierVisitations::VisitVerifiedGroup.call
        Contract(
          Contracts::KeywordArgs[
            group_member_identifier: Cogitate::Interfaces::IdentifierInterface, guest: Cogitate::Interfaces::VisitorInterface,
            repository: RespondTo[:with_verified_group_identifier_related_to]
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
          verified_group_identifier_enumerator.each do |group_identifier|
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
          @verified_group_identifier_enumerator = repository.with_verified_group_identifier_related_to(identifier: group_member_identifier)
        end

        attr_reader :verified_group_identifier_enumerator

        def default_repository
          require 'cogitate/query_repository'
          Cogitate::QueryRepository.new
        end
      end
    end
  end
end
