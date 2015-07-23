require 'cogitate/interfaces'

class Identifier
  # An identifier that has not been verified via some mechanism.
  class Unverified
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

    def attribute_keys
      []
    end

    extend Forwardable
    include Comparable
    def_delegators :identifier, :<=>, :identifying_value

    def strategy
      "unverified/#{identifier.strategy}"
    end

    private

    attr_accessor :identifier
  end
end