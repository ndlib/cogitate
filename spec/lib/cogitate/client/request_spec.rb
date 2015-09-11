require 'spec_fast_helper'
require 'cogitate/client'
require 'cogitate/client/request'
require 'cogitate/configuration'
require 'shoulda/matchers'

RSpec.describe Cogitate::Client::Request do
  let(:identifier_1) { Cogitate::Client.encoded_identifier_for(strategy: 'netid', identifying_value: 'hworld') }
  let(:identifier_2) { Cogitate::Client.encoded_identifier_for(strategy: 'orcid', identifying_value: '0001-0002-0003-0004') }
  let(:configuration) do
    Cogitate::Configuration.new(client_request_handler: client_request_handler, remote_server_base_url: 'http://world.com')
  end
  let(:client_request_handler) { double(call: :the_body) }
  let(:response_parser) { double(call: :parsed_response) }

  subject do
    described_class.new(identifiers: [identifier_1, identifier_2], configuration: configuration, response_parser: response_parser)
  end
  its(:default_configuration) { should respond_to(:url_for_retrieving_agents_for) }
  its(:default_configuration) { should respond_to(:client_request_handler) }

  include Cogitate::RSpecMatchers

  it { should delegate_method(:client_request_handler).to(:configuration) }

  it 'exposes .call as a convenience method' do
    expect_any_instance_of(described_class).to receive(:call)
    described_class.call(identifiers: [identifier_1, identifier_2], configuration: configuration, response_parser: response_parser)
  end

  it 'will parse the response from Cogitate mapping the emails to each of the given identifiers' do
    expect(subject.call).to eq(:parsed_response)
  end

  it 'will use the proper interface for the client_request_handler' do
    subject.call
    expect(client_request_handler).to have_received(:call).with(url: subject.send(:url_for_request))
  end

  it 'will use the proper interface for the response_parser' do
    subject.call
    expect(response_parser).to have_received(:call).with(response: client_request_handler.call)
  end
end
