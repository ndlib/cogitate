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
      # @param [Hash] keywords
      # @option keywords [#call] :identifier_builder converts the 'id' into an Cogitate::Models::Identifier
      # @return [Cogitate::Models::Agent]
      # @raise KeyError if the input data is not well formed
      def self.call(data:, **keywords)
        new(data: data, **keywords).call
      end

      # @api private
      def initialize(data:, identifier_guard: default_identifier_guard, **keywords)
        self.data = data
        self.identifier_guard = identifier_guard
        self.identifier_builder = keywords.fetch(:identifier_builder) { default_identifier_builder }
        self.agent_builder = keywords.fetch(:agent_builder) { default_agent_builder }
        set_agent!
      end

      # @api private
      def call
        assign_identifiers_to_agent
        assign_verified_identifiers_to_agent
        agent
      end

      private

      def assign_identifiers_to_agent
        with_assigning_relationship_for(key: 'identifiers') do |identifier|
          agent.add_identifier(identifier)
        end
      end

      def assign_verified_identifiers_to_agent
        with_assigning_relationship_for(key: 'verified_identifiers') do |identifier|
          agent.add_verified_identifier(identifier)
          next unless identifier.respond_to?(:email)
          agent.add_email(identifier.email)
        end
      end

      def with_assigning_relationship_for(key:)
        data.fetch('relationships').fetch(key).each do |relationship|
          identifier = identifier_builder.call(encoded_identifier: relationship.fetch('id'), included: data.fetch('included', []))
          next unless identifier_guard.call(identifier: identifier)
          yield(identifier)
        end
      end

      attr_accessor :data, :identifier_builder, :identifier_guard, :agent_builder
      attr_reader :agent

      def set_agent!
        @agent = agent_builder.call(encoded_identifier: data.fetch('id'))
      end

      # @api private
      # Because the identifiers decoder returns an array; However I want a single object.
      def default_identifier_builder
        require 'cogitate/client/identifier_builder' unless defined? Services::IdentifierBuilder
        Client::IdentifierBuilder
      end

      # @api private
      def default_agent_builder
        require 'cogitate/models/agent' unless defined? Cogitate::Models::Agent
        Cogitate::Models::Agent.method(:build_with_encoded_id)
      end

      def default_identifier_guard
        -> (*) { true }
      end
    end
  end
end
