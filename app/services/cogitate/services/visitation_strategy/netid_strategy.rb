require 'cogitate/interfaces'

module Cogitate
  module Services
    module VisitationStrategy
      # A containing module for various strategies of invitation
      module NetidStrategy
        # :nodoc:
        # @api Private
        class Base
          include Contracts

          def initialize(identifier:)
            self.identifier = identifier
          end

          def invite(visitor)
            visitor.visit(identifier) { |agent_builder| receive(agent_builder) }
          end

          private

          # @note Contracts are not inherited; Which is another reason to favor composition
          Contract(Cogitate::Interfaces::AgentBuilderInterface => Cogitate::Interfaces::Any)
          def receive(_agent)
            fail NotImplementedError, "You must implement #{self.class}#receive(agent_builder)."
          end

          attr_accessor :identifier
        end
        private_constant :Base

        # Responsible for inviting a visitor and performing the business logic
        # of building up the identifiers for a verified netid.
        #
        # @see #receive
        # @todo Favor composition over inheritance; But as of now, I have two patterns
        class Verified < Base
          private

          Contract(Cogitate::Interfaces::AgentBuilderInterface => Cogitate::Interfaces::Any)
          def receive(agent_builder)
            agent_builder.add_identity(identifier)
            agent_builder.add_verified_authentication_vector(identifier)
          end
        end

        # Responsible for inviting a visitor and performing the business logic
        # of building up the identifiers for an unverified netid.
        #
        # @see #receive
        class Unverified < Base
          private

          Contract(Cogitate::Interfaces::AgentBuilderInterface => Cogitate::Interfaces::Any)
          def receive(agent_builder)
            agent_builder.add_identity(identifier)
          end
        end
      end
    end
  end
end
