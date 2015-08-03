require 'cogitate/interfaces'

# An identifier that has been verified, and may be decorated with additional information
class Identifier
  module Verified
    # A verified Netid
    class Netid
      ATTRIBUTE_NAMES = %w(first_name last_name netid full_name ndguid).freeze

      include Contracts
      Contract(
        Contracts::KeywordArgs[identifier: Cogitate::Interfaces::IdentifierInterface, attributes: Hash] =>
        Cogitate::Interfaces::AuthenticationVectorNetidInterface
      )
      def initialize(identifier:, attributes:)
        self.identifier = identifier
        attributes.each_pair do |key, value|
          next unless ATTRIBUTE_NAMES.include?(key.to_s)
          send("#{key}=", value) if respond_to?("#{key}=", true)
        end
        self
      end

      def verified?
        true
      end

      def attribute_keys
        ATTRIBUTE_NAMES
      end

      attr_reader(*ATTRIBUTE_NAMES)

      extend Forwardable
      include Comparable
      # TODO: Consider if :<=> should be a mixin module for comparison? In delegating down to the identifier, I'm ignoring that
      #   I could be comparing a verified identifier to an unverified identifier and say they are the same.
      def_delegators :identifier, :identifying_value, :<=>, :base_identifying_value, :base_strategy

      def strategy
        "verified/#{identifier.strategy}"
      end

      private

      attr_accessor :identifier

      attr_writer(*ATTRIBUTE_NAMES)
    end
  end
end
