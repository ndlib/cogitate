require 'figaro'
require 'jwt'

module Cogitate
  module Services
    # Responsible for decoding a token and encoding a token.
    #
    # @note This is a slight deviation from some of the class architecture in that there are two primary functions .from_token and
    #    .to_token. There is an underlying parameter object (i.e. password, issuer claim, and encryption type) that can be teased apart
    #    and thus create 1 data structure and 2 isolated functions instead of the bundled 1 object.
    # @see https://github.com/jwt/ruby-jwt
    class Tokenizer
      # @api public
      #
      # Responsible for decoding a signed and encoded token and returning the `:data` portion of the JWT (JSON Web Token).
      #
      # @param token [String] An encoded token (as encoded via .to_token)
      # @return the :data from the given token
      # @see Cogitate::Services::Tokenizer.to_token
      def self.from_token(token:, **keywords)
        new(**keywords).from_token(token: token)
      end

      # @api public
      #
      # Responsible for encoding and signing a token who's `:data` payload is the input data.
      #
      # @param data [#as_json] An object that can be converted to a Hash as per #as_json
      # @return [String] an encoded and signed token
      # @see Cogitate::Services::Tokenizer.from_token
      def self.to_token(data:, **keywords)
        new(**keywords).to_token(data: data)
      end

      def initialize(configuration: default_configuration)
        self.configuration = configuration
      end

      def to_token(data:)
        JWT.encode({ data: data.as_json, iss: issuer_claim }, coerced_password, encryption_type)
      end

      def from_token(token:)
        JWT.decode(token, coerced_password, false, 'iss' => issuer_claim, verify_iss: true).first.fetch('data')
      end

      private

      attr_accessor :configuration

      # I need to coerce the password into the correct format.
      def coerced_password
        case encryption_type.to_s
        when /\ARS\d/i
          OpenSSL::PKey::RSA.new(password)
        else
          encryption_type
        end
      end

      def default_configuration
        require 'cogitate'
        Cogitate.configuration
      end

      # @note In the case of a Cogitate client this should be a public key; In the case of the Cogitate server this should be a private key.
      def password
        configuration.tokenizer_password
      end

      def encryption_type
        configuration.tokenizer_encryption_type
      end

      def issuer_claim
        configuration.tokenizer_issuer_claim
      end
    end
  end
end
