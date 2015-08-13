require 'rails_helper'

RSpec.describe Cogitate::Models::IdentifierTicket, type: :model do
  context '#create_ticket_from_identifier' do
    let(:identifier) { double('Identifier', encoded_id: '1234') }
    it 'will increment the count' do
      expect do
        described_class.create_ticket_from_identifier(identifier: identifier, ticket: '123')
      end.to change { described_class.count }.by(1)
    end
  end
end
