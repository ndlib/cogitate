require 'spec_fast_helper'
require 'cogitate/client'

RSpec.describe Cogitate::Client do
  context '.encoded_identifier_for' do
    it 'should return a string' do
      expect(described_class.encoded_identifier_for(strategy: 'netid', identifying_value: 'hworld')).to be_a(String)
    end
  end

  it 'delegates .retrieve_token_from to TicketToTokenCoercer' do
    ticket = double
    expect(Cogitate::Client::TicketToTokenCoercer).to receive(:call).with(ticket: ticket)
    described_class.retrieve_token_from(ticket: ticket)
  end

  it 'delegates .extract_agent_from to TicketToTokenCoercer' do
    token = double
    expect(Cogitate::Client::TokenToObjectCoercer).to receive(:call).with(token: token)
    described_class.extract_agent_from(token: token)
  end

  it 'delegates .retrieve_primary_emails_associated_with to IdentifiersToEmailsExtractor' do
    identifiers = double
    expect(Cogitate::Client::IdentifiersToEmailsExtractor).to receive(:call).with(identifiers: identifiers)
    described_class.retrieve_primary_emails_associated_with(identifiers: identifiers)
  end
end
