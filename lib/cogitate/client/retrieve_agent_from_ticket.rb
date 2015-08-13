require 'cogitate/interfaces'
module Cogitate
  module Client
    # Responsible for converting a ticket into an agent
    class RetrieveAgentFromTicket
      # @api public
      def self.call(ticket:, **keywords)
        new(ticket: ticket, **keywords).call
      end

      def initialize(ticket:, ticket_coercer: default_ticket_coercer, token_coercer: default_token_coercer)
        self.ticket = ticket
        self.ticket_coercer = ticket_coercer
        self.token_coercer = token_coercer
      end

      include Contracts
      Contract(Contracts::None => Cogitate::Interfaces::AgentInterface)
      def call
        token = ticket_coercer.call(ticket: ticket)
        token_coercer.call(token: token)
      end

      private

      attr_accessor :ticket, :ticket_coercer, :token_coercer

      def default_ticket_coercer
        # Responsible for issuing a request back to the Cogitate Server and reading the body
      end

      def default_token_coercer
        # Responsible for taking a token and coercing it into an agent
      end
    end
  end
end
