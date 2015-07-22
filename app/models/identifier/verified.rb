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

      attr_reader(*ATTRIBUTE_NAMES)

      extend Forwardable
      include Comparable
      def_delegators :identifier, :strategy, :<=>

      # TODO: Should we guard that the identifying_value and the netid are the same?
      alias_method :identifying_value, :netid

      private

      attr_accessor :identifier

      attr_writer(*ATTRIBUTE_NAMES)
    end
  end
end
