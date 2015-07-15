require 'contracts'
require 'cogitate/parameters/identifier'

module Cogitate
  module Services
    module AgentExtractor
      # Responsible for extracting the relevant information based on a given Netid
      class NetidStrategy
        include Contracts

        Contract(KeywordArgs[identity: Parameters::Identifier::Interface] => Any)
        def initialize(identity:)
          self.identity = identity
          self.agent = agent
        end


        AgentInterface = RespondTo[:identities, :verified_authentication_vectors]
        Contract(KeywordArgs[agent: AgentInterface] => AgentInterface)
        def call(agent: default_agent)
          agent.identities << identity
          agent.verified_authentication_vectors << identity if fetch_remote_data_for_netid
          agent
        end

        private

        attr_accessor :identity, :agent

        def fetch_remote_data_for_netid
        end

        def default_agent
          []
        end
      end
    end
  end
end
