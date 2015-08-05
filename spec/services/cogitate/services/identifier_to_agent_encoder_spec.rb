require 'spec_fast_helper'
require 'cogitate/services/identifier_to_agent_encoder'
require 'identifier'

module Cogitate
  module Services
    RSpec.describe IdentifierToAgentEncoder do
      let(:identifier) { Identifier.new(strategy: 'netid', identifying_value: 'hello-world') }
      let(:agent_extractor) { double('Extractor', call: true) }
      let(:agent_tokenizer) { double('Tokenizer', call: true) }
      subject { described_class.new(identifier: identifier, agent_extractor: agent_extractor, agent_tokenizer: agent_tokenizer) }

      include Cogitate::RSpecMatchers

      its(:default_agent_extractor) { should respond_to(:call) }
      its(:default_agent_tokenizer) { should respond_to(:call) }

      context '#call' do
        it 'will extract the agent then tokenize it' do
          agent = double('Agent')
          token = double('Token')
          expect(agent_tokenizer).to receive(:call).with(agent: agent).and_return(token)
          expect(agent_extractor).to receive(:call).with(identifier: identifier).and_return(agent)
          expect(subject.call).to eq(token)
        end
      end

      it 'will expose .call as a public convenience method' do
        expect_any_instance_of(described_class).to receive(:call)
        described_class.call(identifier: identifier)
      end
    end
  end
end
