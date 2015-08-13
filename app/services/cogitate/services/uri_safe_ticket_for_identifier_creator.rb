module Cogitate
  module Services
    # Responsible for creating a ticket for a given identifier.
    module UriSafeTicketForIdentifierCreator
      def self.call(identifier:, repository: default_repository, ticket_maker: default_ticket_maker)
        ticket = ticket_maker.call
        repository.create_ticket_from_identifier(identifier: identifier, ticket: ticket)
        ticket
      end

      def self.default_repository
        require 'cogitate/models/identifier_ticket' unless defined?(Cogitate::Models::IdentifierTicket)
        Cogitate::Models::IdentifierTicket
      end
      private_class_method :default_repository

      def self.default_ticket_maker
        require 'securerandom'
        SecureRandom.method(:urlsafe_base64)
      end
      private_class_method :default_ticket_maker
    end
  end
end
