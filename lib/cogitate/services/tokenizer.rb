require 'figaro'
require 'jwt'

module Cogitate
  module Services
    # Responsible for decoding a token and encoding a token.
    class Tokenizer
      # @return the :data from the given token
      def self.from_token(token:, **keywords)
        new(**keywords).from_token(token: token)
      end

      def self.to_token(data:, **keywords)
        new(**keywords).to_token(data: data)
      end

      def initialize(encryption_type: default_encryption_type, password: default_password, issuer_claim: default_issuer_claim)
        self.encryption_type = encryption_type
        self.password = password
        self.issuer_claim = issuer_claim
      end

      def to_token(data:)
        JWT.encode({ data: data.as_json, iss: issuer_claim }, coerced_password, encryption_type)
      end

      def from_token(token:)
        JWT.decode(token, coerced_password, false, 'iss' => issuer_claim, verify_iss: true).first.fetch('data')
      end

      private

      attr_accessor :encryption_type, :password, :issuer_claim

      # I need to coerce the password into the correct format.
      def coerced_password
        case encryption_type.to_s
        when /\ARS\d/i
          OpenSSL::PKey::RSA.new(password)
        else
          encryption_type
        end
      end

      # Perhaps a bit non-committal but I want to allow for different ENV variables
      def default_password
        Figaro.env.cogitate_services_tokenizer_private_password ||
          Figaro.env.cogitate_services_tokenizer_public_password ||
          Figaro.env.cogitate_services_tokenizer_password!
      end

      def default_encryption_type
        Figaro.env.cogitate_services_tokenizer_encryption_type!
      end

      def default_issuer_claim
        Figaro.env.cogitate_services_tokenizer_issuer_claim!
      end
    end
  end
end
