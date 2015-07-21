require 'contracts'
require 'cogitate/interfaces'

# A parameter object that defines how we go from decoding identifiers to extracting an identity.
class Identifier
  include Contracts

  Contract(Cogitate::Interfaces::IdentifierInitializationInterface => Cogitate::Interfaces::IdentifierInterface)
  def initialize(strategy:, identifying_value:)
    self.strategy = strategy
    self.identifying_value = identifying_value
    self
  end

  attr_reader :strategy, :identifying_value

  include Comparable

  Contract(Cogitate::Interfaces::IdentifierInterface => Num)
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
