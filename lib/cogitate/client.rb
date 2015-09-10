require 'base64'
require 'cogitate/exceptions'
require 'cogitate/client/ticket_to_token_coercer'
require 'cogitate/client/token_to_object_coercer'
require 'cogitate/client/response_parsers/email_extractor'
require 'cogitate/client/request'

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
    def self.extract_strategy_and_identifying_value(encoded_string)
      Base64.urlsafe_decode64(encoded_string).split("\t")
    rescue ArgumentError
      raise Cogitate::InvalidIdentifierEncoding, encoded_string: encoded_string
    end

    # @api public
    def self.retrieve_token_from(ticket:)
      TicketToTokenCoercer.call(ticket: ticket)
    end

    # @api public
    def self.extract_agent_from(token:)
      TokenToObjectCoercer.call(token: token)
    end

    # @api public
    #
    # @param identifiers [Array<String>]
    def self.retrieve_primary_emails_associated_with(identifiers:)
      request(identifiers: identifiers, response_parser: :Email)
    end

    # @api public
    #
    # @param identifiers [Array<String>]
    # @param response_parser [#call(response:)]
    def self.request(identifiers:, response_parser: :AgentsWithDetailedIdentfiers)
      coerced_parser = response_parser_for(response_parser)
      Request.call(identifiers: identifiers, response_parser: coerced_parser)
    end

    # @api public
    # @param object [String, Symbol, #call]
    # @return #call(identifier:)
    def self.response_parser_for(object)
      ResponseParsers.fetch(object)
    end
  end
end
