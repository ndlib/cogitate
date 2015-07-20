require 'contracts'
require 'cogitate/interfaces'

module Cogitate
  module Services
    module IdentifyingHostExtractor
      # Responsible for determining the host that will be leveraged for inviting the agent.
      #
      # @api public
      class NetidStrategy
        include Contracts

        # The Any keyword is a requirement for initialize methods
        #
        # @api public
        Contract(
          KeywordArgs[
            identifier: Cogitate::Interfaces::IdentifierInterface,
            repository: Contracts::Optional[Cogitate::Interfaces::FindNetidRepositoryInterface],
            host_builder: Contracts::Optional[Cogitate::Interfaces::HostBuilderInterface]
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
        class Host
          include Contracts
          Contract(Cogitate::Interfaces::HostInitializationInterface => Cogitate::Interfaces::HostInterface)
          def initialize(invitation_strategy:, identifier:)
            self.invitation_strategy = invitation_strategy
            self.identifier = identifier
            self
          end

          Contract(Cogitate::Interfaces::VisitorInterface => Cogitate::Interfaces::VisitorInterface)
          def invite(guest)
            guest.visit(self) { |visitor| receive(visitor) }
            guest
          end

          private

          attr_accessor :invitation_strategy, :identifier

          def receive(visitor)
            send("receive_#{invitation_strategy}", visitor)
          end

          def receive_unverified(visitor)
            visitor.add_identity(identifier)
          end

          def receive_verified(visitor)
            visitor.add_identity(identifier)
            visitor.add_verified_authentication_vector(identifier)
          end
        end
        private_constant :Host
      end
    end
  end
end