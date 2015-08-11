require 'base64'
require 'contracts'
require 'cogitate/interfaces'

module Cogitate
  module Models
    # @api public
    #
    # A parameter object that defines how we go from decoding identifiers to extracting an identity.
    class Identifier
      include Contracts

      # @api public
      Contract(Cogitate::Interfaces::IdentifierInitializationInterface => Cogitate::Interfaces::IdentifierInterface)
      def initialize(strategy:, identifying_value:)
        self.strategy = strategy
        self.identifying_value = identifying_value
        self
      end

      # @api public
      # @return [String]
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
      # @return [String]
      attr_reader :identifying_value

      # @return [Hash]
      def as_json(*)
        { 'identifying_value' => identifying_value, 'strategy' => strategy }
      end

      include Comparable

      # @api public
      Contract(Cogitate::Interfaces::IdentifierInterface => Num)
      def <=>(other)
        strategy_sort = strategy <=> other.strategy
        return strategy_sort if strategy_sort != 0
        identifying_value <=> other.identifying_value
      end

      # @api public
      # @return [String]
      def encoded_id
        Base64.urlsafe_encode64("#{strategy}\t#{identifying_value}")
      end

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
