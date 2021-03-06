require 'spec_fast_helper'
require 'cogitate/services/agent_extractor'
require "cogitate/models/identifier"

module Cogitate
  module Services
    RSpec.describe AgentExtractor do
      let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: 'a_netid') }
      let(:identifier_extractor) { double(call: true) }
      subject { described_class.new(identifier: identifier, identifier_extractor: identifier_extractor) }

      include Cogitate::RSpecMatchers

      its(:default_identifier_extractor) { should respond_to(:call) }
      its(:default_visitor_builder) { should respond_to(:call) }

      context '.call' do
        it 'is a convenience method and public API endpoint' do
          expect_any_instance_of(described_class).to receive(:call)
          described_class.call(identifier: identifier)
        end
      end

      context '#call' do
        it 'will return an agent' do
          expect(subject.call).to contractually_honor(Cogitate::Interfaces::AgentInterface)
        end
        it 'will leverage the identifying host extractor' do
          subject.call
          expect(identifier_extractor).to have_received(:call).with(
            identifier: identifier, visitor: subject.send(:visitor), visitation_type: :first
          )
        end
      end
    end
  end
end
