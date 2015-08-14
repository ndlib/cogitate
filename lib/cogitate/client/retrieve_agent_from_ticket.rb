require 'cogitate/interfaces'
require 'cogitate/models/agent/with_token'

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
      Contract(Contracts::None => Cogitate::Interfaces::AgentWithTokenInterface)
      def call
        token = ticket_coercer.call(ticket: ticket)
        agent = token_coercer.call(token: token)
        Cogitate::Models::Agent::WithToken.new(token: token, agent: agent)
      end

      private

      attr_accessor :ticket, :ticket_coercer, :token_coercer

      def default_ticket_coercer
        # Responsible for issuing a request back to the Cogitate Server and reading the body
        require 'cogitate/client/ticket_to_token_coercer' unless defined?(TicketToTokenCoercer)
        TicketToTokenCoercer
      end

      def default_token_coercer
        require 'cogitate/client/token_to_object_coercer' unless defined?(TokenToObjectCoercer)
        TokenToObjectCoercer
      end
    end
  end
end
