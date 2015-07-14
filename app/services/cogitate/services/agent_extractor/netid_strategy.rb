module Cogitate
  module Services
    module AgentExtractor
      # Responsible for extracting the relevant information based on a given Netid
      class NetidStrategy
        def initialize(identity:, agent: default_agent)
          self.identity = identity
          self.agent = agent
        end

        def call
          agent.identities << identity
          agent.verified_authentication_vectors << identity if fetch_remote_data_for_netid
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
