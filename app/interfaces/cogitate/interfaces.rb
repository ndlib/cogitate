require 'contracts'

module Cogitate
  # Herein lies the Cogitate namespace
  module Interfaces
    AgentInterface = Contracts::RespondTo[:identities, :verified_authentication_vectors]
    IdentifierInterface = Contracts::RespondTo[:strategy, :identifying_value, :<=>]

    AuthenticationVectorNetidInterface = Contracts::And[
      Contracts::RespondTo[:first_name, :last_name, :netid, :full_name, :ndguid, :strategy, :identifying_value],
      IdentifierInterface
    ]

    IdentifierInitializationInterface = Contracts::KeywordArgs[strategy: Contracts::RespondTo[:to_s], identifying_value: Contracts::Any]
    IdentifierBuilderInterface = Contracts::Func[IdentifierInitializationInterface]
  end
end
