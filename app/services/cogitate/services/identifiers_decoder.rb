require 'base64'

module Cogitate
  module Services
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

      module_function

      # Responsible for decoding a string into a collection of identifier types and identifier ids
      #
      # @param encoded_string [#to_s] The thing we are going to decode
      # @return [Array[Hash]]
      # @raise InvalidIdentifierFormat
      # @raise InvalidIdentifierEncoding
      #
      # @api private
      # @note I have chosen to not use a strategyword, as I don't want to imply the "form" of object is that is being passed in.
      # @todo Determine if we should return an Array of hashes or if it should be a more proper class?
      def call(encoded_string)
        decoded_string = decode(encoded_string)

        decoded_string.split("\n").each_with_object([]) do |strategy_value, object|
          strategy, value = strategy_value.split("\t")
          fail InvalidIdentifierFormat.new(decoded_string: decoded_string) if strategy.to_s.size == 0 || value.to_s.size == 0
          object << { strategy.to_s.downcase.to_sym => value }
        end
      end

      def decode(encoded_string)
        begin
          Base64.urlsafe_decode64(encoded_string.to_s)
        rescue ArgumentError
          raise InvalidIdentifierEncoding.new(encoded_string: encoded_string)
        end
      end
      private_class_method :decode
    end
  end
end
