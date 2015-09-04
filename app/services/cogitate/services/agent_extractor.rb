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
      def initialize(identifier:, visitor_builder: default_visitor_builder, identifier_extractor: default_identifier_extractor)
        self.identifier = identifier
        self.visitor = visitor_builder.call(identifier: identifier)
        self.identifier_extractor = identifier_extractor
      end

      Contract(Contracts::None => Cogitate::Interfaces::AgentInterface)
      def call
        identifier_extractor.call(identifier: identifier, visitor: visitor, visitation_type: :first)
        visitor.return_from_visitations
      end

      private

      attr_accessor :identifier, :identifier_extractor
      attr_reader :visitor

      Contract(Cogitate::Interfaces::VisitorV2Interface => Cogitate::Interfaces::VisitorV2Interface)
      attr_writer :visitor

      def default_identifier_extractor
        require 'cogitate/services/identifier_extractor' unless defined?(IdentifierExtractor)
        IdentifierExtractor
      end

      def default_visitor_builder
        require 'cogitate/models/agent/visitor' unless defined?(Models::Agent::Visitor)
        Models::Agent::Visitor.method(:build)
      end
    end
  end
end
