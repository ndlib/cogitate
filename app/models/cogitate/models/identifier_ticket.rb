require 'active_record'

module Cogitate
  module Models
    # Responsible for persisting a ticket that is associated with an encoded_id of
    # an identifier.
    class IdentifierTicket < ActiveRecord::Base
      self.table_name = 'cogitate_models_identifier_tickets'

      def self.create_ticket_from_identifier(identifier:, ticket:, expires_at: 10.minutes.from_now)
        self.create!(encoded_id: identifier.encoded_id, ticket: ticket, expires_at: expires_at)
      end
    end
  end
end
