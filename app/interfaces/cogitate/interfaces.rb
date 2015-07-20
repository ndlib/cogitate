require 'contracts'

module Cogitate
  # Herein lies the Cogitate namespace
  module Interfaces
    include Contracts
    AgentInterface = RespondTo[:identities, :verified_authentication_vectors]
    AgentBuilderInterface = RespondTo[:add_identity, :add_verified_authentication_vector]

    HostInterface = RespondTo[:invite]
    VisitorInterface = RespondTo[:visit]

    # All identifiers must be comparable, otherwise we could spiral into an endless visitation of related identifiers
    IdentifierInterface = RespondTo[:strategy, :identifying_value, :<=>]
    VerifiedAuthenticationVectorInterface = RespondTo[:strategy, :identifying_value, :<=>]

    AuthenticationVectorNetidInterface = And[
      RespondTo[:first_name, :last_name, :netid, :full_name, :ndguid, :strategy, :identifying_value],
      IdentifierInterface
    ]

    IdentifierInitializationInterface = KeywordArgs[strategy: RespondTo[:to_s], identifying_value: Any]
    IdentifierBuilderInterface = Func[IdentifierInitializationInterface]

    FindNetidRepositoryInterface = RespondTo[:find]

    VerifiableIdentifierInterface = And[IdentifierInterface, RespondTo[:verified?]]
  end
end
