require 'spec_fast_helper'
require 'cogitate/client/retrieve_agent_from_ticket'
require 'cogitate/models/agent'
require 'cogitate/models/agent/with_token'
require 'cogitate/models/identifier'

RSpec.describe Cogitate::Client::RetrieveAgentFromTicket do
  its(:default_token_coercer) { should respond_to(:call) }
  its(:default_ticket_coercer) { should respond_to(:call) }

  let(:token_coercer) { double('TokenCoercer', call: agent) }
  let(:ticket_coercer) { double('TicketCoercer', call: token) }
  let(:agent) { Cogitate::Models::Agent.new(identifier: identifier) }
  let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: 'hworld') }
  let(:token) { 'this-is-a-token' }
  let(:ticket) { double('Ticket') }
  subject { described_class.new(ticket: ticket, token_coercer: token_coercer, ticket_coercer: ticket_coercer) }

  it 'will expose .call as a convenience method' do
    expect_any_instance_of(described_class).to receive(:call)
    described_class.call(ticket: ticket)
  end

  context '#call' do
    it 'will leverage the token coercer to coerce the token to an agent' do
      subject.call
      expect(token_coercer).to have_received(:call).with(token: token)
    end
    it 'will leverage the ticket coercer to coerce the ticket to a token' do
      subject.call
      expect(ticket_coercer).to have_received(:call).with(ticket: ticket)
    end
  end
end
