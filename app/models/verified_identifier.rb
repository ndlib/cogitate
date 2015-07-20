require 'cogitate/interfaces'
# An identifier that has been verified, and may be decorated with additional information
module VerifiedIdentifier
  # A verified Netid
  class Netid
    include Contracts
    Contract(
      Contracts::KeywordArgs[identifier: Cogitate::Interfaces::IdentifierInterface, attributes: Hash] =>
      Cogitate::Interfaces::AuthenticationVectorNetidInterface
    )
    def initialize(identifier:, attributes:)
      self.identifier = identifier
      attributes.each_pair do |key, value|
        send("#{key}=", value) if respond_to?("#{key}=", true)
      end
      self
    end

    def verified?
      true
    end

    attr_reader :first_name, :last_name, :netid, :full_name, :ndguid

    extend Forwardable
    include Comparable
    def_delegators :identifier, :strategy, :<=>

    # TODO: Should we guard that the identifying_value and the netid are the same?
    alias_method :identifying_value, :netid

    private

    attr_accessor :identifier

    attr_writer :first_name, :last_name, :netid, :full_name, :ndguid
  end
end
