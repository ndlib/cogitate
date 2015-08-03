require 'contracts'

module Cogitate
  # Herein lies the Cogitate namespace
  module Interfaces
    include Contracts
    IdentifierInterface = RespondTo[:strategy, :identifying_value, :<=>, :base_identifier]
    IdentifierCollectionInterface = Contracts::ArrayOf[Cogitate::Interfaces::IdentifierInterface]

    AgentInterface = RespondTo[:identities, :verified_authentication_vectors]
    AgentCollectionInterface = Contracts::ArrayOf[Cogitate::Interfaces::AgentInterface]
    IdentityCollectorInterface = RespondTo[:add_identity, :add_verified_authentication_vector, :visit]

    VisitorInterface = RespondTo[:visit]
    VisitorV2Interface = And[VisitorInterface, RespondTo[:return_from_visitations]]
    AgentCollectorInitializationInterface = KeywordArgs[visitor: VisitorInterface, agent: Optional[AgentInterface]]

    # All identifiers must be comparable, otherwise we could spiral into an endless visitation of related identifiers
    VerifiedIdentifierInterface = IdentifierInterface

    AuthenticationVectorNetidInterface = And[
      RespondTo[:first_name, :last_name, :netid, :full_name, :ndguid, :strategy, :identifying_value],
      IdentifierInterface
    ]

    HostInterface = RespondTo[:invite]
    HostInitializationInterface = KeywordArgs[invitation_strategy: Symbol, identifier: IdentifierInterface]
    HostBuilderInterface = Func[HostInitializationInterface]

    IdentifierInitializationInterface = KeywordArgs[strategy: RespondTo[:to_s], identifying_value: Any]
    IdentifierBuilderInterface = Func[IdentifierInitializationInterface]

    FindNetidRepositoryInterface = RespondTo[:find]

    VerifiableIdentifierInterface = And[IdentifierInterface, RespondTo[:verified?]]
  end
end
