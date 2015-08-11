module Cogitate
  module Client
    # Responsible for decoding a Cogitate token.
    #
    # @see Cogitate::Services::AgentTokenizer
    class TokenDecoder
      def self.call(token:)
        new(token: token).call
      end

      def initialize(token:)
        self.token = token
      end

      def call
      end

      private

      attr_accessor :token
    end
  end
end
