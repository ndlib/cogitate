require 'spec_fast_helper'
require 'cogitate/services/agent_extractor'
require 'identifier'

module Cogitate
  module Services
    RSpec.describe AgentExtractor do
      let(:identifier) { Identifier.new(strategy: 'netid', identifying_value: 'a_netid') }
      let(:identifying_host_extractor) { double(call: true) }
      subject { described_class.new(identifier: identifier, identifying_host_extractor: identifying_host_extractor) }

      include Cogitate::RSpecMatchers

      its(:default_identifying_host_extractor) { should respond_to(:call) }
      its(:default_visitor) { should contractually_honor(Cogitate::Interfaces::VisitorV2Interface) }

      context '.call' do
        it 'will return an agent' do
          expect(subject.call).to contractually_honor(Cogitate::Interfaces::AgentInterface)
        end
        it 'will leverage the identifying host extractor' do
          subject.call
          expect(identifying_host_extractor).to have_received(:call).with(identifier: identifier, visitor: subject.send(:visitor))
        end
      end
    end
  end
end
