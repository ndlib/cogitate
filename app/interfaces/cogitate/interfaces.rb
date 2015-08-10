require 'contracts'

module Cogitate
  # Herein lies the Cogitate namespace
  module Interfaces
    include Contracts
    IdentifierInterface = RespondTo[:strategy, :identifying_value, :<=>]
    IdentifierCollectionInterface = Contracts::ArrayOf[Cogitate::Interfaces::IdentifierInterface]

    AgentInterface = RespondTo[
      :with_identifiers, :with_verified_identifiers, :with_emails, :add_identifier, :add_verified_identifier, :add_email
    ]
    AgentCollectionInterface = Contracts::ArrayOf[Cogitate::Interfaces::AgentInterface]

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
    HostInitializationInterface = KeywordArgs[
      invitation_strategy: Symbol, identifier: IdentifierInterface, group_visitation_service: Optional[RespondTo[:call]]
    ]
    HostBuilderInterface = Func[HostInitializationInterface]

    IdentifierInitializationInterface = KeywordArgs[strategy: RespondTo[:to_s], identifying_value: Any]
    IdentifierBuilderInterface = Func[IdentifierInitializationInterface]

    FindNetidRepositoryInterface = RespondTo[:find]

    VerifiableIdentifierInterface = And[IdentifierInterface, RespondTo[:verified?]]
    VerifiedGroupInterface = And[VerifiableIdentifierInterface, RespondTo[:name, :description]]
  end
end
