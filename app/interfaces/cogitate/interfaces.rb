require 'contracts'

module Cogitate
  # Herein lies the Cogitate namespace
  module Interfaces
    AgentInterface = Contracts::RespondTo[:identities, :verified_authentication_vectors]

    AuthenticationVectorNetidInterface = Contracts::RespondTo[:first_name, :last_name, :netid, :full_name, :ndguid]

    IdentifierInitializationInterface = Contracts::KeywordArgs[strategy: Contracts::RespondTo[:to_s], identifying_value: Contracts::Any]
    IdentifierBuilderInterface = Contracts::Func[IdentifierInitializationInterface]
    IdentifierInterface = Contracts::RespondTo[:strategy, :identifying_value, :<=>]
  end
end
