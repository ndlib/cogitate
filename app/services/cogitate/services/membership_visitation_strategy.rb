require 'cogitate/services/membership_visitation_strategies/do_not_visit_memberships_service'
require 'cogitate/services/membership_visitation_strategies/visit_groups_for_verified_member'
require 'cogitate/services/membership_visitation_strategies/visit_members_for_verified_group'
require 'cogitate/exceptions'

module Cogitate
  module Service
    # A container for finding the appropriate strategy for membership visitation
    module MembershipVisitationStrategy
      LOOKUP_TABLE = {
        first: {
          verified: {
            'group' => :VisitMembersForVerifiedGroup,
            default: :VisitGroupsForVerifiedMember
          },
          unverified: {
            default: :DoNotVisitMembershipsService
          }
        },
        continuing: {
          verified: {
            default: :DoNotVisitMembershipsService
          },
          unverified: {
            default: :DoNotVisitMembershipsService
          }
        }
      }.freeze
      def self.find(identifier:, visitation_type:)
        subtable = subtable_for(identifier: identifier, visitation_type: visitation_type)
        membership_vistation_strategy = subtable.fetch(identifier.strategy, subtable.fetch(:default))
        Services::MembershipVisitationStrategies.const_get(membership_vistation_strategy)
      end

      def self.subtable_for(identifier:, visitation_type:)
        verification_type = identifier.verified? ? :verified : :unverified
        LOOKUP_TABLE.fetch(visitation_type).fetch(verification_type)
      rescue KeyError
        raise Cogitate::InvalidMembershipVisitationKeys, identifier: identifier, visitation_type: visitation_type
      end
      private_class_method :subtable_for
    end
  end
end
