require 'rails_helper'

RSpec.describe Cogitate::Models::IdentifierTicket, type: :model do
  let(:encoded_id) { "bmV0aWQJaHdvcmxk" }
  let(:identifier) { double('Identifier', encoded_id: encoded_id) }
  let(:ticket) { '123-456' }
  context '.default_identifier_decoder' do
    it 'will convert an encoded identifier' do
      expect(described_class.default_identifier_decoder.call(encoded_identifier: encoded_id)).to be_a(Cogitate::Models::Identifier)
    end
  end
  context '.create_ticket_from_identifier' do
    it 'will increment the count' do
      expect do
        described_class.create_ticket_from_identifier(identifier: identifier, ticket: ticket)
      end.to change { described_class.count }.by(1)
    end
  end

  context '.find_current_identifier_for' do
    it 'find the given ticket and return an identifier' do
      described_class.create_ticket_from_identifier(identifier: identifier, ticket: ticket)
      expect(described_class.find_current_identifier_for(ticket: ticket).encoded_id).to eq(encoded_id)
    end

    it 'will raise an exception if one is not found' do
      expect { described_class.find_current_identifier_for(ticket: ticket) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
