module Cogitate
  module Services
    # This class is responsible for:
    # * Convertin an Identifier to a corresponding Agent, then encoding that Agent as a JSON Web Token
    class IdentifierToAgentEncoder
      def initialize(identifier:, agent_extractor: default_agent_extractor, agent_tokenizer: default_agent_tokenizer)
        self.identifier = identifier
        self.agent_extractor = agent_extractor
        self.agent_tokenizer = agent_tokenizer
      end

      def call
        agent = agent_extractor.call(identifier: identifier)
        agent_tokenizer.call(agent: agent)
      end

      private

      attr_accessor :identifier, :agent_extractor, :agent_tokenizer

      def default_agent_extractor
        require 'cogitate/services/agent_extractor' unless defined?(Cogitate::Services::AgentExtractor)
        Cogitate::Services::AgentExtractor
      end

      def default_agent_tokenizer
        require 'cogitate/services/agent_tokenizer' unless defined?(Cogitate::Services::AgentTokenizer)
        Cogitate::Services::AgentTokenizer
      end
    end
  end
end
