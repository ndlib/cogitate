module Cogitate
  module Client
    # Responsible for decoding a Cogitate token into an object (or objects)
    #
    # @see Cogitate::Services::Tokenizer for how the tokens get encoded and decoded
    class TokenToObjectCoercer
      # @api public
      def self.call(token:, **keywords)
        new(token: token, **keywords).call
      end

      def initialize(token:, token_to_data_coercer: default_token_to_data_coercer, data_to_object_coercer: default_data_to_object_coercer)
        self.token = token
        self.token_to_data_coercer = token_to_data_coercer
        self.data_to_object_coercer = data_to_object_coercer
      end

      def call
        data = token_to_data_coercer.call(token: token)
        data_to_object_coercer.call(data: data)
      end

      private

      attr_accessor :token, :token_to_data_coercer, :data_to_object_coercer

      def default_token_to_data_coercer
        require 'cogitate/services/tokenizer' unless defined?(Cogitate::Services::Tokenizer)
        Cogitate::Services::Tokenizer.method(:from_token)
      end

      def default_data_to_object_coercer
        require 'cogitate/client/data_to_object_coercer' unless defined?(Cogitate::Client::DataToObjectCoercer)
        Cogitate::Client::DataToObjectCoercer
      end
    end
  end
end
