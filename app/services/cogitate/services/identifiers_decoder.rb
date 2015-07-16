require 'base64'
require 'contracts'
require 'cogitate/interfaces'

module Cogitate
  module Services
    # A service module for extracting identifiers from an encoded payload.
    #
    # @see Cogitate::Services::IdentifieresDecoder.call
    module IdentifiersDecoder
      # When the thing we are trying to decode is improperly encoded, this exception is to provide clarity
      class InvalidIdentifierEncoding < ArgumentError
        def initialize(encoded_string:)
          super("Unable to decode #{encoded_string}; Expected it to be URL-safe Base64 encoded (use Base64.urlsafe_encode64)")
        end
      end

      # When the thing we have decoded is not properly formated, this exception is to provide clarity
      class InvalidIdentifierFormat < RuntimeError
        EXPECTED_FORMAT = "strategy\tvalue\nstrategy\tvalue".freeze
        def initialize(decoded_string:)
          super("Expected #{decoded_string.inspect} to be of the format #{EXPECTED_FORMAT.inspect}")
        end
      end

      # Responsible for decoding a string into a collection of identifier types and identifier ids
      #
      # @param encoded_string [#to_s] The thing we are going to decode
      # @return [Array[Hash]]
      # @raise InvalidIdentifierFormat
      # @raise InvalidIdentifierEncoding
      #
      # @api private
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
          if strategy.to_s.size == 0 || value.to_s.size == 0
            fail InvalidIdentifierFormat, decoded_string: decoded_string
          end
          object << identifier_builder.call(strategy: strategy, identifying_value: value)
        end
      end

      def self.decode(encoded_string)
        Base64.urlsafe_decode64(encoded_string.to_s)
      rescue ArgumentError
        raise InvalidIdentifierEncoding, encoded_string: encoded_string
      end
      private_class_method :decode

      def self.default_identifier_builder
        require 'cogitate/parameters/identifier' unless defined?(Parameters::Identifier)
        Parameters::Identifier.method(:new)
      end
    end
  end
end
