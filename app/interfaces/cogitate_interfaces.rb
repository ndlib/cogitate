require 'contracts'

# Herein lies the Cogitate namespace
module Cogitate
  AgentInterface = Contracts::RespondTo[:identities, :verified_authentication_vectors]

  IdentifierInterface = Contracts::RespondTo[:strategy, :identifying_value]

  IdentifierInitializationInterface = Contracts::KeywordArgs[strategy: Contracts::RespondTo[:to_s], identifying_value: Contracts::Any]

  IdentifierBuilderInterface = Contracts::Func[IdentifierInitializationInterface]
end
