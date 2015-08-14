require 'rest-client'
module Cogitate
  module Client
    # Responsible for converting a ticket into a token by leveraging a remote call to a Cogitate server.
    class TicketToTokenCoercer
      # @api public
      # @param ticket [String] A ticket issued by a Cogitate server
      # @return token [String] An encoded token
      #
      # @see Cogitate::Services::UriSafeTicketForIdentifierCreator
      def self.call(ticket:, **keywords)
        new(ticket: ticket, **keywords).call
      end

      def initialize(ticket:, configuration: default_configuration)
        self.ticket = ticket
        self.configuration = configuration
      end

      def call
        response = RestClient.get(configuration.url_for_claiming_a_ticket, params: { ticket: ticket })
        response.body
      end

      private

      attr_accessor :ticket, :configuration

      def default_configuration
        require 'cogitate'
        Cogitate.configuration
      end
    end
  end
end
