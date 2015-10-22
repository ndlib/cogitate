require 'cogitate/interfaces'
module Cogitate
  module Services
    module IdentifierExtractors
      # Responsible for extracting the host that will oversee the visitation of the agent
      class GroupStrategy
        extend Contracts

        Contract(Cogitate::Interfaces::HostBuilderInterface)
        # @api public
        def self.call(identifier:, membership_visitation_service:)
          new(identifier: identifier, membership_visitation_service: membership_visitation_service)
        end

        def initialize(identifier:, membership_visitation_service:, repository: default_repository)
          self.identifier = identifier
          self.repository = repository
          self.membership_visitation_service = membership_visitation_service
        end

        def invite(guest)
          guest.visit(identifier) { |visitor| receive(visitor) }
          guest
        end

        private

        attr_accessor :identifier, :repository, :membership_visitation_service

        def receive(visitor)
          identifier_is_verified = false
          repository.with_verified_existing_group_for(identifier: identifier) do |verified_identifier|
            identifier_is_verified = true
            visitor.add_identifier(verified_identifier)
            visitor.add_verified_identifier(verified_identifier)
            membership_visitation_service.call(identifier: verified_identifier, visitor: visitor)
          end
          visitor.add_identifier(identifier) unless identifier_is_verified
        end

        def default_repository
          require 'cogitate/query_repository' unless defined?(Cogitate::QueryRepository)
          Cogitate::QueryRepository.new
        end
      end
    end
  end
end
