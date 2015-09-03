require 'cogitate/interfaces'
module Cogitate
  module Services
    module InitialIdentifierExtractor
      # Responsible for extracting the host that will oversee the visitation of the agent
      class GroupStrategy
        extend Contracts

        Contract(Contracts::KeywordArgs[identifier: Cogitate::Interfaces::IdentifierInterface] => Cogitate::Interfaces::HostInterface)
        # @api public
        def self.call(identifier:)
          new(identifier: identifier)
        end

        def initialize(identifier:, repository: default_repository, member_visitation_service: default_member_visitation_service)
          self.identifier = identifier
          self.repository = repository
          self.member_visitation_service = member_visitation_service
        end

        def invite(guest)
          guest.visit(identifier) { |visitor| receive(visitor) }
          guest
        end

        private

        attr_accessor :identifier, :repository, :member_visitation_service

        def receive(visitor)
          identifier_is_verified = false
          repository.with_verified_existing_group_for(identifier: identifier) do |verified_identifier|
            identifier_is_verified = true
            visitor.add_identifier(verified_identifier)
            visitor.add_verified_identifier(verified_identifier)
            member_visitation_service.call(identifier: verified_identifier, visitor: visitor)
          end
          visitor.add_identifier(identifier) unless identifier_is_verified
        end

        def default_repository
          require 'cogitate/query_repository' unless defined?(Cogitate::QueryRepository)
          Cogitate::QueryRepository.new
        end

        def default_member_visitation_service
          require 'cogitate/services/identifier_visitations/visit_members_for_verified_group'
          IdentifierVisitations::VisitMembersForVerifiedGroup
        end
      end
    end
  end
end
