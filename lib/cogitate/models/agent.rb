require 'cogitate/interfaces'
require 'base64'

module Cogitate
  module Models
    # @api public
    #
    # An Agent is a "bucket" of attributes. It represents a single acting entity:
    #
    # * a Person - the human clacking away at the keyboard requesting things
    # * a Service - an application that "does stuff" to data
    class Agent
      include Contracts
      # @note I'm choosing the :identifier as the input and :primary_identifier as the attribute. I believe it is possible that during the
      #       process that builds the Agent, I may encounter a more applicable primary_identifier.
      Contract(
        Contracts::KeywordArgs[identifier: Cogitate::Interfaces::IdentifierInterface], Contracts::Any =>
        Cogitate::Interfaces::AgentInterface
      )
      def initialize(identifier:, container: default_container, serializer_builder: default_serializer_builder)
        self.identifiers = container.new
        self.verified_identifiers = container.new
        self.primary_identifier = identifier
        self.serializer = serializer_builder.call(agent: self)
        self.emails = container.new
        yield(self) if block_given?
        self
      end

      # @api public
      Contract(Cogitate::Interfaces::IdentifierInterface => Cogitate::Interfaces::IdentifierInterface)
      def add_identifier(identifier)
        identifiers << identifier
        identifier
      end

      # @api public
      def with_identifiers
        return enum_for(:with_identifiers) unless block_given?
        identifiers.each { |identifier| yield(identifier) }
      end

      # @api public
      Contract(Cogitate::Interfaces::IdentifierInterface => Cogitate::Interfaces::IdentifierInterface)
      def add_verified_identifier(identifier)
        verified_identifiers << identifier
        identifier
      end

      # @api public
      def with_verified_identifiers
        return enum_for(:with_verified_identifiers) unless block_given?
        verified_identifiers.each { |identifier| yield(identifier) }
      end

      # @api private
      # I am not yet set on this method being part of the public API.
      def add_email(input)
        emails << input
      end

      # @api public
      def with_emails
        return enum_for(:with_emails) unless block_given?
        emails.each { |email| yield(email) }
      end

      # @return [Cogitate::Interfaces::IdentifierInterface] What has been assigned as the primary identifier of this agent.
      attr_reader :primary_identifier

      extend Forwardable
      def_delegators :primary_identifier, :strategy, :identifying_value, :encoded_id
      def_delegators :serializer, :as_json

      private

      attr_accessor :identifiers, :verified_identifiers, :emails

      Contract(Cogitate::Interfaces::IdentifierInterface => Contracts::Any)
      attr_writer :primary_identifier

      def default_container
        require 'set' unless defined?(Set)
        Set
      end

      attr_accessor :serializer
      # @todo This is something that needs greater consideration. Is it applicable for both client and server?
      def default_serializer_builder
        require 'cogitate/models/agent/serializer' unless defined?(Cogitate::Models::Agent::Serializer)
        Cogitate::Models::Agent::Serializer.method(:new)
      end
    end
  end
end
