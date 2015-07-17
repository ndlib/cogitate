require 'contracts'

module Cogitate
  # Herein lies the Cogitate namespace
  module Interfaces
    include Contracts
    AgentInterface = RespondTo[:identities, :verified_authentication_vectors]
    InvitationInterface = RespondTo[:invite]
    VisitorInterface = RespondTo[:visit]

    # All identifiers must be comparable, otherwise we could spiral into an endless visitation of related identifiers
    IdentifierInterface = RespondTo[:strategy, :identifying_value, :<=>]

    AuthenticationVectorNetidInterface = And[
      RespondTo[:first_name, :last_name, :netid, :full_name, :ndguid, :strategy, :identifying_value],
      IdentifierInterface
    ]

    IdentifierInitializationInterface = KeywordArgs[strategy: RespondTo[:to_s], identifying_value: Any]
    IdentifierBuilderInterface = Func[IdentifierInitializationInterface]

    FindNetidRepositoryInterface = RespondTo[:find]
  end
end
