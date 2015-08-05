require 'cogitate/interfaces'
require 'figaro'
require 'jwt'

module Cogitate
  module Services
    # Responsible for serializing an Agent to JSON and encoding that JSON using JSON Web Token
    # encoding (jwt).
    class AgentTokenizer
      # @api public
      def self.call(agent:, **keywords)
        new(agent: agent, **keywords).call
      end

      def initialize(agent:, **keywords)
        self.agent = agent
        self.encryption_type = keywords.fetch(:encryption_type) { default_encryption_type }
        self.password = keywords.fetch(:password) { default_password }
        self.issuer_claim = keywords.fetch(:issuer_claim) { default_issuer_claim }
      end

      # @api public
      #
      # @return [String] An encoded (and perhaps encrypted) string. It is decodable (and decryptable) via the jwt gem.
      # @see https://github.com/jwt/ruby-jwt
      def call
        JWT.encode(payload, coerced_password, encryption_type)
      end

      private

      # @api private
      def payload
        { data: agent.as_json, iss: issuer_claim }
      end

      # I need to coerce the password into the correct format.
      def coerced_password
        case encryption_type.to_s
        when /\ARS\d/i
          OpenSSL::PKey::RSA.new(password)
        else
          encryption_type
        end
      end

      attr_accessor :agent, :password, :encryption_type, :issuer_claim

      def default_password
        Figaro.env.agent_tokenizer_private_password
      end

      def default_encryption_type
        Figaro.env.agent_tokenizer_encryption_type
      end

      def default_issuer_claim
        Figaro.env.agent_tokenizer_issuer_claim
      end
    end
  end
end
