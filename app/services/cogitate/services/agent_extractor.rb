require 'cogitate/interfaces'

module Cogitate
  module Services
    # Responsible for coordinating the conversion of a single Identifier into an Agent
    class AgentExtractor
      # @api public
      def self.call(identifier:, **keywords)
        new(identifier: identifier, **keywords).call
      end

      include Contracts
      def initialize(identifier:, visitor: default_visitor, identifying_host_extractor: default_identifying_host_extractor)
        self.identifier = identifier
        self.visitor = visitor
        self.identifying_host_extractor = identifying_host_extractor
      end

      Contract(Contracts::None => Cogitate::Interfaces::AgentInterface)
      def call
        identifying_host_extractor.call(identifier: identifier, visitor: visitor)
        visitor.return_from_visitations
      end

      private

      attr_accessor :identifier, :identifying_host_extractor
      attr_reader :visitor

      Contract(Cogitate::Interfaces::VisitorV2Interface => Cogitate::Interfaces::VisitorV2Interface)
      attr_writer :visitor

      def default_identifying_host_extractor
        require_relative './identifying_host_extractor' unless defined?(IdentifyingHostExtractor)
        IdentifyingHostExtractor
      end

      def default_visitor
        require 'agent_visitor' unless defined?(AgentVisitor)
        AgentVisitor.new
      end
    end
  end
end
