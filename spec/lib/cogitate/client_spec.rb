require 'spec_fast_helper'
require 'cogitate/client'
require 'cogitate/client/ticket_to_token_coercer'

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
end
