require 'contracts'
require 'cogitate_interfaces'
module Cogitate
  module Parameters
    # A parameter object that defines how we go from decoding identifiers to extracting an identity.
    class Identifier
      include Contracts
      extend Contracts

      # Ensuring that the Identifier object does in fact adhear to its defined Interface
      Contract(IdentifierInitializationInterface => Cogitate::IdentifierInterface)
      def self.new(*args)
        super
      end

      Contract(Cogitate::IdentifierInitializationInterface => Cogitate::IdentifierInterface)
      def initialize(strategy:, identifying_value:)
        self.strategy = strategy
        self.identifying_value = identifying_value
        self
      end

      attr_reader :strategy, :identifying_value

      include Comparable

      Contract(Cogitate::IdentifierInterface => Num)
      def <=>(other)
        strategy_sort = strategy <=> other.strategy
        return strategy_sort if strategy_sort != 0
        identifying_value <=> other.identifying_value
      end

      private

      attr_writer :identifying_value

      def strategy=(value)
        @strategy = value.to_s.downcase
      end
    end
  end
end
