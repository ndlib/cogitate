require 'active_support/core_ext/array/wrap'

module Cogitate
  module Client
    # Responsible for extracting the primary email for each of the given identifiers.
    #
    # @note In the case where an identifier is a group, it will extract the primary emails for each member of the group.
    class IdentifiersToEmailsExtractor
      # @api public
      def self.call(identifiers:, **keywords)
        new(identifiers: identifiers, **keywords).call
      end

      def initialize(identifiers:, configuration: default_configuration)
        self.identifiers = identifiers
        self.configuration = configuration
        initialize_urlsafe_base64_encoded_identifiers!
        initialize_url_for_request!
      end

      def call
        response = RestClient.get(url_for_request)
        parse(response: response.body)
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

      def parse(response:)
        data = JSON.parse(response).fetch('data')
        data.each_with_object({}) do |datum, mem|
          mem[datum.fetch('id')] = datum.fetch('attributes').fetch('emails')
          mem
        end
      end

      def default_configuration
        require 'cogitate'
        Cogitate.configuration
      end
    end
  end
end
