require 'cogitate/models/agent'

module Cogitate
  module Client
    # Responsible for transforming a well formed Hash into an Agent and its constituent parts.
    #
    # @see Cogitate::Models::Agent
    # @see Cogitate::Client::AgentBuilder.call
    class AgentBuilder
      # @api public
      #
      # Responsible for transforming a well formed Hash into an Agent and its constituent parts.
      #
      # @param data [Hash] with string keys
      # @param identifier_decoder [#call] converts the 'id' into an Cogitate::Models::Identifier
      # @return Cogitate::Models::Agent
      # @raise KeyError if the input data is not well formed
      def self.call(data, **keywords)
        new(data, **keywords).call
      end

      # @api private
      def initialize(data, identifier_decoder: default_identifier_decoder)
        self.data = data
        self.identifier_decoder = identifier_decoder
        set_agent!
      end

      # @api private
      def call
        data.fetch('attributes').fetch('emails').each { |email| agent.add_email(email) }
        # TODO: Add any included information
        data.fetch('relationships').fetch('identifiers').each do |stub|
          agent.add_identifier(identifier_decoder.call(stub.fetch('id')))
        end
        data.fetch('relationships').fetch('verified_identifiers').each do |stub|
          agent.add_verified_identifier(identifier_decoder.call(stub.fetch('id')))
        end
        agent
      end

      private

      attr_accessor :data, :identifier_decoder
      attr_reader :agent

      def set_agent!
        identifier = identifier_decoder.call(data.fetch('id'))
        @agent = Models::Agent.new(identifier: identifier)
      end

      # @api private
      # Because the identifiers decoder returns an array; However I want a single object.
      def default_identifier_decoder
        require 'cogitate/services/identifiers_decoder' unless defined? Services::IdentifiersDecoder
        ->(encoded_id) { Services::IdentifiersDecoder.call(encoded_id).first }
      end
    end
  end
end
