require 'spec_fast_helper'
require 'cogitate/client'
require 'cogitate/client/identifiers_to_emails_extractor'

RSpec.describe Cogitate::Client::IdentifiersToEmailsExtractor do
  let(:identifier_1) { Cogitate::Client.encoded_identifier_for(strategy: 'netid', identifying_value: 'hworld') }
  let(:identifier_2) { Cogitate::Client.encoded_identifier_for(strategy: 'orcid', identifying_value: '0001-0002-0003-0004') }
  let(:response_parser) { double('Response Parser', call: :parsed_response) }
  let(:configuration) { double(url_for_retrieving_agents_for: 'http://world.com') }
  its(:default_response_parser) { should respond_to(:call) }
  its(:default_configuration) { should respond_to(:url_for_retrieving_agents_for) }

  subject do
    described_class.new(identifiers: [identifier_1, identifier_2], response_parser: response_parser, configuration: configuration)
  end

  before { allow(RestClient).to receive(:get).and_return(:response_from_request) }

  it 'exposes .call as a convenience method' do
    expect_any_instance_of(described_class).to receive(:call)
    described_class.call(identifiers: [identifier_1, identifier_2], response_parser: response_parser, configuration: configuration)
  end

  it 'will request the agents for a single Cogitate encoded string from the Cogitate application' do
    expect(RestClient).to receive(:get).with(configuration.url_for_retrieving_agents_for)
    subject.call
  end

  it 'will build the url_for_retrieving_agents_for based on the given identifiers' do
    subject
    expect(configuration).to have_received(:url_for_retrieving_agents_for).with(
      urlsafe_base64_encoded_identifiers: subject.send(:urlsafe_base64_encoded_identifiers)
    )
  end

  it 'will parse the response from Cogitate mapping the emails to each of the given identifiers' do
    subject.call
    expect(response_parser).to have_received(:call).with(response: :response_from_request)
  end
end
