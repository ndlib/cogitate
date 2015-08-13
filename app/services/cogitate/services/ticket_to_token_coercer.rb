module Cogitate
  module Services
    # Responsible for converting a Ticket into a serialized Token
    module TicketToTokenCoercer
      def self.call(ticket:, repository: default_repository, identifier_tokenizer: default_identifier_tokenizer)
        identifier = repository.find_current_identifier_for(ticket: ticket)
        identifier_tokenizer.call(identifier: identifier)
      end

      def self.default_repository
        require 'cogitate/models/identifier_ticket'
        Cogitate::Models::IdentifierTicket
      end
      private_class_method :default_repository

      def self.default_identifier_tokenizer
        require 'cogitate/services/identifier_to_agent_encoder' unless defined?(IdentifierToAgentEncoder)
        IdentifierToAgentEncoder
      end
      private_class_method :default_identifier_tokenizer
    end
  end
end
