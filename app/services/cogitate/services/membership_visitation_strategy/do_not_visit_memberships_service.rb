module Cogitate
  module Services
    module MembershipVisitationStrategy
      # Sometimes we don't want to delve too deeply across the group boundary.
      module DoNotVisitMembershipsService
        # @api public
        def self.call(*)
        end
      end
    end
  end
end
