require 'cogitate/interfaces'

# An identifier that has not been verified via some mechanism.
class UnverifiedIdentifier
  include Contracts
  Contract(
    Contracts::KeywordArgs[identifier: Cogitate::Interfaces::IdentifierInterface] =>
    Cogitate::Interfaces::VerifiableIdentifierInterface
  )
  def initialize(identifier:)
    self.identifier = identifier
    self
  end

  def verified?
    false
  end

  extend Forwardable
  include Comparable
  def_delegators :identifier, :strategy, :<=>, :identifying_value

  private

  attr_accessor :identifier
end
