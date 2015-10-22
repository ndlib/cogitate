require 'contracts'
require 'cogitate/interfaces'

module Cogitate
  module Services
    module IdentifierExtractors
      # Responsible for determining the host that will be leveraged for inviting the agent.
      #
      # @api public
      class NetidStrategy
        extend Contracts
        Contract(Cogitate::Interfaces::HostBuilderInterface)
        # @api public
        def self.call(identifier:, membership_visitation_service:)
          new(identifier: identifier, membership_visitation_service: membership_visitation_service).call
        end

        include Contracts
        # The Any keyword is a requirement for initialize methods
        #
        # @api public
        Contract(
          KeywordArgs[
            identifier: Cogitate::Interfaces::IdentifierInterface,
            membership_visitation_service: Cogitate::Interfaces::MembershipVisitationStrategyInterface,
            repository: Contracts::Optional[Cogitate::Interfaces::FindNetidRepositoryInterface],
            host_builder: Contracts::Optional[RespondTo[:call]]
          ] => Any
        )
        def initialize(identifier:, membership_visitation_service:, repository: default_repository, host_builder: default_host_builder)
          self.identifier = identifier
          self.repository = repository
          self.host_builder = host_builder
          self.membership_visitation_service = membership_visitation_service
        end

        # @api public
        Contract(Contracts::None => Cogitate::Interfaces::HostInterface)
        def call
          remote_identifier = repository.find(identifier: identifier)
          host_builder.call(
            identifier: remote_identifier,
            membership_visitation_service: membership_visitation_service,
            invitation_strategy: invitation_strategy(remote_identifier: remote_identifier)
          )
        end

        private

        def invitation_strategy(remote_identifier:)
          return :verified if remote_identifier.verified?
          :unverified
        end

        attr_accessor :identifier, :repository, :host_builder, :membership_visitation_service

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
          def initialize(invitation_strategy:, identifier:, membership_visitation_service:)
            self.invitation_strategy = invitation_strategy
            self.identifier = identifier
            self.membership_visitation_service = membership_visitation_service
          end

          Contract(Cogitate::Interfaces::VisitorInterface => Cogitate::Interfaces::VisitorInterface)
          def invite(guest)
            guest.visit(identifier) { |visitor| receive(visitor) }
            guest
          end

          private

          attr_accessor :invitation_strategy, :identifier, :membership_visitation_service

          def receive(visitor)
            send("receive_#{invitation_strategy}", visitor)
          end

          def receive_unverified(visitor)
            visitor.add_identifier(identifier)
          end

          def receive_verified(visitor)
            visitor.add_identifier(identifier)
            visitor.add_verified_identifier(identifier)
            membership_visitation_service.call(identifier: identifier, visitor: visitor)
          end
        end
        private_constant :Host
      end
    end
  end
end
