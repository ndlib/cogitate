require 'contracts'
require 'cogitate/interfaces'

module Cogitate
  module Services
    module IdentifyingHostExtractor
      # Responsible for determining the host that will be leveraged for inviting the agent.
      class NetidStrategy
        include Contracts

        # The Any keyword is a requirement for initialize methods
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

        Contract(Contracts::None => Cogitate::Interfaces::HostInterface)
        def call
          verified_identifier = repository.find(identifier: identifier)
          if verified_identifier.present?
            host_builder.call(invitation_strategy: :verified, identifier: verified_identifier)
          else
            host_builder.call(invitation_strategy: :unverified, identifier: identifier)
          end
        end

        private

        attr_accessor :identifier, :repository, :host_builder

        def default_repository
          require 'cogitate/repositories/remote_netid_repository'
          Repositories::RemoteNetidRepository
        end

        def default_host_builder
          Host.method(:new)
        end

        # Responsible for inviting a guest to come and visit. A visiting guest will be received according to the invitation strategy.
        class Host
          include Contracts
          Contract(KeywordArgs[invitation_strategy: Symbol, identifier: Cogitate::Interfaces::IdentifierInterface] => Any)
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
