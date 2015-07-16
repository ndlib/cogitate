require 'contracts'
require 'cogitate/interfaces'

module Cogitate
  module Services
    module AgentExtractor
      # Responsible for extracting the relevant information based on a given Netid
      class NetidStrategy
        include Contracts

        # The Any keyword is a requirement for initialize methods
        Contract(KeywordArgs[identity: Cogitate::Interfaces::IdentifierInterface] => Any)
        def initialize(identity:)
          self.identity = identity
          self.agent = agent
        end

        Contract(KeywordArgs[agent: Cogitate::Interfaces::AgentInterface] => Cogitate::Interfaces::AgentInterface)
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
