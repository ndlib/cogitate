module Cogitate
  module Services
    module VisitationStrategy
      # A containing module for various strategies of invitation
      module NetidStrategy
        class Base
          def initialize(identifier:)
            self.identifier = identifier
          end

          def invite(visitor)
            visitor.visit(identifier) { |agent| receive(agent) }
          end

          private

          def receive(agent)
            fail NotImplementedError, "You must implement #{self.class}#receive."
          end

          attr_accessor :identifier
        end
        private_constant :Base

        # Responsible for inviting a visitor and performing the business logic
        # of building up the identifiers for a verified netid.
        #
        # @see #receive
        class Verified < Base
          private

          def receive(agent)
            agent.identifiers << identifier
            agent.verified_authentication_vectors << identifier
          end
        end

        # Responsible for inviting a visitor and performing the business logic
        # of building up the identifiers for an unverified netid.
        #
        # @see #receive
        class Unverified < Base
          private

          def receive(agent)
            agent.identifiers << identifier
          end
        end
      end
    end
  end
end
