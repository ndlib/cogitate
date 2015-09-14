require 'active_record'
require 'active_support/core_ext/numeric/time'

module Cogitate
  module Models
    # Responsible for persisting a ticket that is associated with an encoded_id of
    # an identifier.
    class IdentifierTicket < ActiveRecord::Base
      self.table_name = 'cogitate_models_identifier_tickets'

      def self.create_ticket_from_identifier(identifier:, ticket:, expires_at: 2.minutes.from_now)
        self.create!(encoded_id: identifier.encoded_id, ticket: ticket, expires_at: expires_at)
      end

      def self.find_current_identifier_for(ticket:, as_of: Time.zone.now, identifier_decoder: default_identifier_decoder)
        identifier_ticket = where("ticket = :ticket AND expires_at > :as_of", ticket: ticket, as_of: as_of).first!
        identifier_decoder.call(encoded_identifier: identifier_ticket.encoded_id)
      end

      def self.default_identifier_decoder
        require 'cogitate/services/identifiers_decoder' unless defined? Services::IdentifiersDecoder
        ->(encoded_identifier:) { Services::IdentifiersDecoder.call(encoded_identifier).first }
      end
    end
  end
end
