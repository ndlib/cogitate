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
      def initialize(identifier:, visitor_builder: default_visitor_builder, initial_identifier_extractor: default_identifier_extractor)
        self.identifier = identifier
        self.visitor = visitor_builder.call(identifier: identifier)
        self.initial_identifier_extractor = initial_identifier_extractor
      end

      Contract(Contracts::None => Cogitate::Interfaces::AgentInterface)
      def call
        initial_identifier_extractor.call(identifier: identifier, visitor: visitor)
        visitor.return_from_visitations
      end

      private

      attr_accessor :identifier, :initial_identifier_extractor
      attr_reader :visitor

      Contract(Cogitate::Interfaces::VisitorV2Interface => Cogitate::Interfaces::VisitorV2Interface)
      attr_writer :visitor

      def default_identifier_extractor
        require 'cogitate/services/identifier_extractors' unless defined?(InitialIdentifierExtractor)
        InitialIdentifierExtractor
      end

      def default_visitor_builder
        require 'cogitate/models/agent/visitor' unless defined?(Models::Agent::Visitor)
        Models::Agent::Visitor.method(:build)
      end
    end
  end
end
