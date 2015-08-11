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
      def initialize(data, identifier_builder: default_identifier_builder)
        self.data = data
        self.identifier_builder = identifier_builder
        set_agent!
      end

      # @api private
      def call
        assign_emails_to_agent
        assign_identifiers_to_agent
        assign_verified_identifiers_to_agent
        agent
      end

      private

      def assign_emails_to_agent
        data.fetch('attributes').fetch('emails').each { |email| agent.add_email(email) }
      end

      def assign_identifiers_to_agent
        data.fetch('relationships').fetch('identifiers').each do |stub|
          identifier = identifier_builder.call(id: stub.fetch('id'), included: data.fetch('included', {}))
          agent.add_identifier(identifier)
        end
      end

      def assign_verified_identifiers_to_agent
        data.fetch('relationships').fetch('verified_identifiers').each do |stub|
          identifier = identifier_builder.call(id: stub.fetch('id'), included: data.fetch('included', {}))
          agent.add_verified_identifier(identifier)
        end
      end

      attr_accessor :data, :identifier_builder
      attr_reader :agent

      def set_agent!
        identifier = identifier_builder.call(id: data.fetch('id'))
        @agent = Models::Agent.new(identifier: identifier)
      end

      # @api private
      # Because the identifiers decoder returns an array; However I want a single object.
      def default_identifier_builder
        require 'cogitate/services/identifiers_decoder' unless defined? Services::IdentifiersDecoder
        ->(id:, **keywords) { Services::IdentifiersDecoder.call(id).first }
      end
    end
  end
end
