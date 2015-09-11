require 'spec_fast_helper'
require 'cogitate/configuration'
require 'rest-client'

RSpec.describe Cogitate::Configuration do
  subject { described_class.new }
  described_class::CONFIG_ATTRIBUTE_NAMES.each do |method_name|
    context "##{method_name}" do
      it 'will use the set value' do
        subject.public_send("#{method_name}=", 'hello')
        expect(subject.public_send(method_name)).to eq('hello')
      end
      it 'will raise an exception if not set' do
        expect { subject.public_send(method_name) }.to raise_error(described_class::ConfigurationError)
      end
    end
  end

  its(:default_client_request_handler) { should respond_to(:call) }

  context '#default_client_request_handler' do
    it 'will have :url keyword parameter' do
      expect(subject.send(:default_client_request_handler).parameters).to eq([[:keyreq, :url]])
    end
  end

  context 'calling the #client_request_handler' do
    it 'will return the body of a RestClient request' do
      url = 'http://hello.com'
      response = double(body: 'The Body')
      expect(RestClient).to receive(:get).with(url).and_return(response)
      expect(subject.client_request_handler.call(url: url)).to eq(response.body)
    end
  end

  context '#url_for_authentication' do
    subject do
      described_class.new(
        remote_server_base_url: 'http://google.com', after_authentication_callback_url: 'https://somewhere.com/after_authentication'
      )
    end
    its(:url_for_authentication) do
      should eq("http://google.com/authenticate?after_authentication_callback_url=#{CGI.escape(subject.after_authentication_callback_url)}")
    end

    its(:url_for_claiming_a_ticket) { should eq("http://google.com/claim") }

    it 'exposes #url_for_retrieving_agents_for' do
      expect(subject.url_for_retrieving_agents_for(urlsafe_base64_encoded_identifiers: '1234')).to eq("http://google.com/api/agents/1234")
    end
  end
end
