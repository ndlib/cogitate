require 'spec_fast_helper'
require 'cogitate/client/token_to_object_coercer'

RSpec.describe Cogitate::Client::TokenToObjectCoercer do
  let(:token) { File.read(File.expand_path('../../../../fixtures/agent_token.jwt.txt', __FILE__)) }
  let(:token_to_data) { double('TokenToDataCoercer', call: data) }
  let(:data_to_object) { double('data_to_object_coercer', call: agent) }
  let(:data) { double('Data') }
  let(:agent) { double('Agent') }
  subject { described_class.new(token: token, token_to_data_coercer: token_to_data, data_to_object_coercer: data_to_object) }

  it 'will expose a .call as part of the public API' do
    expect_any_instance_of(described_class).to receive(:call)
    described_class.call(token: token)
  end

  its(:default_token_to_data_coercer) { should respond_to(:call) }
  its(:default_data_to_object_coercer) { should respond_to(:call) }

  context '#call' do
    it 'will return the results of token to data to agent coercion' do
      expect(subject.call).to eq(agent)
    end

    it 'will call the token_to_data_coercer to retrieve data' do
      subject.call
      expect(token_to_data).to have_received(:call).with(token: token)
    end

    it 'will call the token_to_agent_coercer to build the agent' do
      subject.call
      expect(data_to_object).to have_received(:call).with(data)
    end
  end
end
