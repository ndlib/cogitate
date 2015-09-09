require 'active_support/core_ext/array/wrap'

module Cogitate
  module Client
    # Request from Cogitate the given identifiers and parse leveraging the custom parser.
    class Request
      # @api public
      def self.call(identifiers:, **keywords)
        new(identifiers: identifiers, **keywords).call
      end

      def initialize(identifiers:, response_parser:, configuration: default_configuration)
        self.identifiers = identifiers
        self.configuration = configuration
        self.response_parser = response_parser
        initialize_urlsafe_base64_encoded_identifiers!
        initialize_url_for_request!
      end

      def call
        response = RestClient.get(url_for_request)
        response_parser.call(response: response.body)
      end

      private

      attr_accessor :response_parser, :configuration

      attr_reader :identifiers, :urlsafe_base64_encoded_identifiers, :url_for_request

      def identifiers=(input)
        @identifiers = Array.wrap(input)
      end

      def initialize_urlsafe_base64_encoded_identifiers!
        @urlsafe_base64_encoded_identifiers = Base64.urlsafe_encode64(
          identifiers.map { |identifier| Base64.urlsafe_decode64(identifier) }.join("\n")
        )
      end

      def initialize_url_for_request!
        @url_for_request = configuration.url_for_retrieving_agents_for(
          urlsafe_base64_encoded_identifiers: urlsafe_base64_encoded_identifiers
        )
      end

      def default_configuration
        require 'cogitate'
        Cogitate.configuration
      end
    end
  end
end
