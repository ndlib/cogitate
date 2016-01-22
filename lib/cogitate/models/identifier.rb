require 'contracts'
require 'cogitate/interfaces'
require 'base64'

module Cogitate
  module Models
    # @api public
    #
    # A parameter object that defines how we go from decoding identifiers to extracting an identity.
    class Identifier
      INTERFACE_METHOD_NAMES = [:identifying_value, :<=>, :encoded_id, :id, :strategy, :name].freeze
      def self.interface_method_names
        INTERFACE_METHOD_NAMES
      end

      GROUP_STRATEGY_NAME = 'group'.freeze
      include Contracts

      # @api public
      #
      # There are implicit groups that exist and are associated with a given strategy.
      # This method exists to create a consistent group name.
      #
      # @param strategy [String] What is the scope of this identifier (i.e. a Netid, email)
      # @return [Cogitate::Models::Identifier]
      def self.new_for_implicit_verified_group_by_strategy(strategy:)
        new(strategy: GROUP_STRATEGY_NAME, identifying_value: %(All Verified "#{strategy.to_s.downcase}" Users))
      end

      Contract(Cogitate::Interfaces::IdentifierInitializationInterface => Cogitate::Interfaces::IdentifierInterface)
      # @api public
      #
      # Initialize a value object for identification
      #
      # @param strategy [String] What is the scope of this identifier (i.e. a Netid, email)
      # @param identifying_value [String] What is the value of this identifier (i.e. hello@test.com)
      def initialize(strategy:, identifying_value:)
        self.strategy = strategy
        self.identifying_value = identifying_value
        self
      end

      # @api public
      #
      # Provides context for the `identifying_value`
      #
      # @example 'netid', 'orcid', 'email', 'twitter' are all potential strategies
      #
      # @return [String] one of the contexts for identity of this object
      # @see #<=>
      attr_reader :strategy

      # @api public
      #
      # For the given `strategy` what is the (hopefully) unique value that can be used for identification?
      #
      # @example
      #   Given a `strategy` of "email", examples of identifying values are:
      #   * hello@world.com
      #   * test@test.com
      #
      #   It is also possible that someone might say 'taco' is an identifying value for the email strategy.
      #   And that is fine.
      #
      # @return [String] one of the contexts for identity of this object
      # @see #<=>
      attr_reader :identifying_value

      alias name identifying_value

      # The JSON representation of this object
      #
      # @return [Hash]
      def as_json(*)
        { 'identifying_value' => identifying_value, 'strategy' => strategy }
      end

      include Comparable

      Contract(Cogitate::Interfaces::IdentifierInterface => Contracts::Num)
      # @api public
      #
      # Provide a means of sorting.
      #
      # @return [Integer] -1, 0, 1 as per `Comparable#<=>` interface
      def <=>(other)
        strategy_sort = strategy <=> other.strategy
        return strategy_sort if strategy_sort != 0
        identifying_value <=> other.identifying_value
      end

      # @api public
      #
      # A URL safe encoding of this object's `strategy` and `identifying_value`
      #
      # @return [String] a URL safe encoding of the object's identifying attributes
      def encoded_id
        Base64.urlsafe_encode64("#{strategy}\t#{identifying_value}")
      end

      alias id encoded_id

      private

      # @api private
      attr_writer :identifying_value

      # @api private
      def strategy=(value)
        @strategy = value.to_s.downcase
      end
    end
  end
end
