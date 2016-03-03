require 'base64'
require 'contracts'
require 'cogitate/interfaces'
require 'cogitate/exceptions'
require 'cogitate/client'

module Cogitate
  module Services
    # A service module for extracting identifiers from an encoded payload.
    #
    # @example
    #
    #   encoded_string = Base64.urlsafe_encode64("netid\tmynetid")
    #
    #
    # @see Cogitate::Services::IdentifieresDecoder.call
    module IdentifiersDecoder
      # Responsible for decoding a string into a collection of identifier types and identifier ids
      #
      # @param encoded_string [#to_s] The thing we are going to decode
      # @return [Array[Hash]]
      # @raise InvalidIdentifierFormat
      # @raise InvalidIdentifierEncoding
      #
      # @api public
      # @note I have chosen to not use a keyword, as I don't want to imply the "form" of object is that is being passed in.
      # @todo Determine if we should return an Array of hashes or if it should be a more proper class?
      extend Contracts
      Contract(
        String, { Contracts::KeywordArgs[identifier_builder: Contracts::Func[Cogitate::Interfaces::IdentifierBuilderInterface]] =>
        Contracts::ArrayOf[Cogitate::Interfaces::IdentifierInterface] }
      )
      def self.call(encoded_string, identifier_builder: default_identifier_builder)
        decoded_string = decode(encoded_string)

        decoded_string.split("\n").each_with_object([]) do |strategy_value, object|
          strategy, value = strategy_value.split("\t")
          if strategy.to_s.empty? || value.to_s.empty?
            raise Cogitate::InvalidIdentifierFormat, decoded_string: decoded_string
          end
          object << identifier_builder.call(strategy: strategy, identifying_value: value)
        end
      end

      # @api private
      def self.decode(encoded_string)
        Base64.urlsafe_decode64(encoded_string.to_s)
      rescue ArgumentError
        raise Cogitate::InvalidIdentifierEncoding, encoded_string: encoded_string
      end
      private_class_method :decode

      # @api private
      def self.default_identifier_builder
        require "cogitate/models/identifier" unless defined?(Cogitate::Models::Identifier)
        Cogitate::Models::Identifier.method(:new)
      end
      private_class_method :default_identifier_builder
    end
  end
end
