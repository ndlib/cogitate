module Cogitate
  module Services
    module MembershipVisitationStrategies
      # Responsible for coordinating a visit to all groups associated with the given identifier.
      class VisitMembersForVerifiedGroup
        # @api public
        def self.call(identifier:, visitor:)
          new(group_identifier: identifier, guest: visitor).call
        end

        def initialize(group_identifier:, guest:, repository: default_repository, identifier_extractor: default_identifier_extractor)
          self.group_identifier = group_identifier
          self.guest = guest
          self.repository = repository
          self.identifier_extractor = identifier_extractor
        end

        # @api public
        def call
          repository.each_identifier_related_to(identifier: group_identifier) do |member_identifier|
            identifier_extractor.call(identifier: member_identifier, visitor: guest, visitation_type: :next)
          end
        end

        private

        attr_accessor :group_identifier, :guest, :repository, :identifier_extractor

        def default_repository
          require 'cogitate/query_repository' unless defined?(Cogitate::QueryRepository)
          Cogitate::QueryRepository.new
        end

        # @todo leverage Services::IdentifierExtractor.call
        def default_identifier_extractor
          require 'cogitate/services/identifier_extractor' unless defined?(Services::IdentifierExtractor)
          IdentifierExtractor
        end
      end
    end
  end
end
