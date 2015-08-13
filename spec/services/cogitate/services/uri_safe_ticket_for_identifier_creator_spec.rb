require 'spec_fast_helper'
require 'cogitate/services/uri_safe_ticket_for_identifier_creator'
require 'cogitate/models/identifier'

RSpec.describe Cogitate::Services::UriSafeTicketForIdentifierCreator do
  let(:repository) { double('Repository', create_ticket_from_identifier: true) }
  let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: 'hworld') }
  let(:ticket_maker) { -> { '123' } }
  subject { described_class }
  it 'will create ticket entry set to expire' do
    expect(repository).to receive(:create_ticket_from_identifier).with(identifier: identifier, ticket: ticket_maker.call)
    expect(subject.call(identifier: identifier, repository: repository, ticket_maker: ticket_maker)).to eq(ticket_maker.call)
  end
  its(:default_repository) { should respond_to(:create_ticket_from_identifier) }
  its(:default_ticket_maker) { should respond_to(:call) }
end
