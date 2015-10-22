require 'contracts'

module Cogitate
  # Herein lies the Cogitate namespace
  module Interfaces
    include Contracts
    IdentifierInterface = RespondTo[:strategy, :identifying_value, :<=>, :name, :id, :encoded_id]
    IdentifierCollectionInterface = Contracts::ArrayOf[Cogitate::Interfaces::IdentifierInterface]

    AgentInterface = RespondTo[
      :with_identifiers, :with_verified_identifiers, :with_emails, :add_identifier, :add_verified_identifier, :add_email, :ids, :name
    ]
    AgentCollectionInterface = Contracts::ArrayOf[Cogitate::Interfaces::AgentInterface]
    AgentWithTokenInterface = And[AgentInterface, RespondTo[:to_token]]

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

    IdentifierInitializationInterface = KeywordArgs[strategy: RespondTo[:to_s], identifying_value: Any]
    IdentifierBuilderInterface = Func[IdentifierInitializationInterface]

    FindNetidRepositoryInterface = RespondTo[:find]

    MembershipVisitationStrategyInterface = RespondTo[:call]
    HostBuilderInterface = {
      Contracts::KeywordArgs[
        identifier: Cogitate::Interfaces::IdentifierInterface,
        membership_visitation_service: Cogitate::Interfaces::MembershipVisitationStrategyInterface
      ] => Cogitate::Interfaces::HostInterface
    }

    VerifiableIdentifierInterface = And[IdentifierInterface, RespondTo[:verified?]]
    VerifiedGroupInterface = And[VerifiableIdentifierInterface, RespondTo[:name, :description]]
  end
end
