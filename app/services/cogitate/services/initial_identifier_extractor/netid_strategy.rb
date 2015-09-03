require 'contracts'
require 'cogitate/interfaces'

module Cogitate
  module Services
    module InitialIdentifierExtractor
      # Responsible for determining the host that will be leveraged for inviting the agent.
      #
      # @api public
      class NetidStrategy
        extend Contracts
        Contract(Contracts::KeywordArgs[identifier: Cogitate::Interfaces::IdentifierInterface] => Cogitate::Interfaces::HostInterface)
        def self.call(identifier:, **keywords)
          new(identifier: identifier, **keywords).call
        end

        include Contracts
        # The Any keyword is a requirement for initialize methods
        #
        # @api public
        Contract(
          KeywordArgs[
            identifier: Cogitate::Interfaces::IdentifierInterface,
            repository: Contracts::Optional[Cogitate::Interfaces::FindNetidRepositoryInterface],
            host_builder: Contracts::Optional[RespondTo[:call]]
          ] => Any
        )
        def initialize(identifier:, repository: default_repository, host_builder: default_host_builder)
          self.identifier = identifier
          self.repository = repository
          self.host_builder = host_builder
        end

        # @api public
        Contract(Contracts::None => Cogitate::Interfaces::HostInterface)
        def call
          remote_identifier = repository.find(identifier: identifier)
          if remote_identifier.verified?
            host_builder.call(invitation_strategy: :verified, identifier: remote_identifier)
          else
            host_builder.call(invitation_strategy: :unverified, identifier: remote_identifier)
          end
        end

        private

        attr_accessor :identifier, :repository, :host_builder

        def default_repository
          require 'cogitate/repositories/remote_netid_repository' unless defined?(Repositories::RemoteNetidRepository)
          Repositories::RemoteNetidRepository
        end

        def default_host_builder
          Host.method(:new)
        end

        # Responsible for inviting a guest to come and visit. A visiting guest will be received according to the invitation strategy.
        #
        # @todo Should this be broken down into two separate classes? I have an #receive_unverified and #receive_verified method.
        class Host
          include Contracts
          def initialize(invitation_strategy:, identifier:, group_visitation_service: default_group_visitation_service)
            self.invitation_strategy = invitation_strategy
            self.identifier = identifier
            self.group_visitation_service = group_visitation_service
          end

          Contract(Cogitate::Interfaces::VisitorInterface => Cogitate::Interfaces::VisitorInterface)
          def invite(guest)
            guest.visit(identifier) { |visitor| receive(visitor) }
            guest
          end

          private

          attr_accessor :invitation_strategy, :identifier, :group_visitation_service

          def receive(visitor)
            send("receive_#{invitation_strategy}", visitor)
          end

          def receive_unverified(visitor)
            visitor.add_identifier(identifier)
          end

          def receive_verified(visitor)
            visitor.add_identifier(identifier)
            visitor.add_verified_identifier(identifier)
            group_visitation_service.call(identifier: identifier, visitor: visitor)
          end

          def default_group_visitation_service
            require 'cogitate/services/identifier_visitations/visit_groups_for_verified_member'
            IdentifierVisitations::VisitGroupsForVerifiedMember
          end
        end
        private_constant :Host
      end
    end
  end
end
