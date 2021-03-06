require 'spec_fast_helper'
require 'cogitate/client'
require 'cogitate/client/response_parsers/email_extractor'

RSpec.describe Cogitate::Client do
  context '.with_custom_configuration' do
    it 'will inject a new configuration within the block scope' do
      old_configuration = Cogitate.configuration
      described_class.with_custom_configuration do
        expect(Cogitate.configuration).to_not eq(old_configuration)
      end
      expect(Cogitate.configuration).to eq(old_configuration)
    end

    it 'allows for custom configuration' do
      described_class.with_custom_configuration(client_request_handler: :hello) do
        expect(Cogitate.configuration.client_request_handler).to eq(:hello)
      end
      expect(Cogitate.configuration.client_request_handler).to_not eq(:hello)
    end
  end
  context '.encoded_identifier_for' do
    it 'should return a string' do
      expect(described_class.encoded_identifier_for(strategy: 'netid', identifying_value: 'hworld')).to be_a(String)
    end
  end

  context '.retrieve_data_from' do
    it 'will retrieve_token_from then extract the token' do
      ticket = double
      token = double
      expect(described_class).to receive(:retrieve_token_from).with(ticket: ticket).and_return(token)
      expect(Cogitate::Services::Tokenizer).to receive(:from_token).with(token: token)
      described_class.retrieve_data_from(ticket: ticket)
    end
  end

  context '.extract_strategy_and_identifying_value' do
    it 'will return two strings' do
      identifier_id = described_class.encoded_identifier_for(strategy: 'netid', identifying_value: 'hworld')
      strategy, identifying_value = described_class.extract_strategy_and_identifying_value(identifier_id)
      expect(strategy).to eq('netid')
      expect(identifying_value).to eq('hworld')
    end

    it 'will raise an error if it is poor encoding' do
      expect { described_class.extract_strategy_and_identifying_value('hworld') }.to raise_error(Cogitate::InvalidIdentifierEncoding)
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

  it 'delegates .retrieve_primary_emails_associated_with to Cogitate::Client::Request' do
    identifiers = double
    expect(Cogitate::Client::Request).to receive(:call).with(
      identifiers: identifiers, response_parser: Cogitate::Client::ResponseParsers::EmailExtractor
    )
    described_class.retrieve_primary_emails_associated_with(identifiers: identifiers)
  end

  it 'delegates .request_agents_without_group_membership to .request' do
    identifiers = double
    expect(described_class).to receive(:request).with(identifiers: identifiers, response_parser: :AgentsWithoutGroupMembership)
    described_class.request_agents_without_group_membership(identifiers: identifiers)
  end

  it 'delegates .request to Cogitate::Client::Request' do
    identifiers = double
    response_parser = double(call: true)
    expect(Cogitate::Client::Request).to receive(:call).with(identifiers: identifiers, response_parser: response_parser)
    described_class.request(identifiers: identifiers, response_parser: response_parser)
  end

  it 'will fetch a response parser' do
    expect(described_class.response_parser_for(:Basic)).to respond_to(:call)
  end
end
