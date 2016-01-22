require 'cogitate/interfaces'

module Cogitate
  module Models
    class Agent
      # A parameter style class that can be sent to the client of Cogitate.
      #
      # The token, if decoded and parsed will be the given agent. Likewise the agent, if encoded would be the given token.
      class WithToken < SimpleDelegator
        include Contracts
        Contract(KeywordArgs[agent: Cogitate::Interfaces::AgentInterface, token: String] => Any)
        def initialize(agent:, token:)
          self.token = token
          self.agent = agent
          super(agent)
        end

        private

        attr_accessor :agent, :token

        alias to_token token
        public :to_token
      end
    end
  end
end
