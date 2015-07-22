require 'cogitate/interfaces'

module Cogitate
  module Services
    # Responsible for mapping encoded identifiers to a collection of Agent objects.
    #
    # @api public
    #
    # @see #call for contract expectations
    class EncodedIdentifiersToAgentsMapper
      # @api public
      def self.call(encoded_identifiers:, **keywords)
        new(encoded_identifiers: encoded_identifiers, **keywords).call
      end

      include Contracts
      Contract(
        Contracts::KeywordArgs[
          encoded_identifiers: String, decoder: Contracts::Optional[RespondTo[:call]], converter: Contracts::Optional[RespondTo[:call]]
        ] => Contracts::RespondTo[:call]
      )
      def initialize(encoded_identifiers:, decoder: default_decoder, converter: default_converter)
        self.encoded_identifiers = encoded_identifiers
        self.decoder = decoder
        self.converter = converter
        self
      end

      private

      attr_accessor :encoded_identifiers, :decoder, :converter

      public

      Contract(Contracts::None => Cogitate::Interfaces::AgentCollectionInterface)
      def call
        identifiers.map { |identifier| convert_to_agent(identifier: identifier) }
      end

      private

      def identifiers
        decoder.call(encoded_identifiers)
      end

      def convert_to_agent(identifier:)
        converter.call(identifier: identifier)
      end

      def default_decoder
        require_relative './identifiers_decoder' unless defined?(IdentifiersDecoder)
        IdentifiersDecoder
      end

      def default_converter
        require_relative './agent_extractor' unless defined?(AgentExtractor)
        AgentExtractor
      end
    end
  end
end
