require 'base64'
require 'cogitate/exceptions'
require 'cogitate/client/ticket_to_token_coercer'

module Cogitate
  # Responsible for collecting the various client related behaviors.
  module Client
    # @api public
    #
    # A URL safe encoding of the given `strategy` and `identifying_value`
    #
    # @param strategy [String]
    # @param identifying_value [String]
    #
    # @return [String] a URL safe encoding of the object's identifying attributes
    #
    # @see Cogitate::Models::Identifier
    def self.encoded_identifier_for(strategy:, identifying_value:)
      Base64.urlsafe_encode64("#{strategy.to_s.downcase}\t#{identifying_value}")
    end

    # @api public
    def self.retrieve_token_from(ticket:)
      TicketToTokenCoercer.call(ticket: ticket)
    end
  end
end
