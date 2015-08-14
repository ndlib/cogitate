require 'spec_fast_helper'
require 'cogitate/client/ticket_to_token_coercer'

RSpec.describe Cogitate::Client::TicketToTokenCoercer do
  let(:ticket) { '123-456' }
  let(:configuration) { double('Config') }
  let(:url) { 'http://cogitate.com' }

  subject { described_class.new(ticket: ticket, configuration: configuration) }
  before { allow(configuration).to receive(:url_for_claiming_a_ticket).and_return(url) }
  its(:default_configuration) { should respond_to(:url_for_claiming_a_ticket) }

  it 'will expose .call as a convenience method' do
    expect_any_instance_of(described_class).to receive(:call)
    described_class.call(ticket: ticket)
  end

  context '#call' do
    let(:response) { double('Response', body: "Hello World") }
    it 'will issue a GET request to the #url_for_claiming_a_ticket' do
      expect(RestClient).to receive(:get).with(url, params: { ticket: '123-456' }).and_return(response)
      expect(subject.call).to eq(response.body)
    end
  end
end
