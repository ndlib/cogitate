require 'spec_fast_helper'
require 'cogitate/services/encoded_identifiers_to_agents_mapper'
require 'identifier'
require 'agent'

module Cogitate
  module Services
    RSpec.describe EncodedIdentifiersToAgentsMapper do
      let(:encoded_identifiers) { "this-is-encoded" }
      let(:decoder_response) { [Identifier.new(strategy: 'netid', identifying_value: 'a netid')] }
      let(:decoder) { double(call: decoder_response) }
      let(:converter) { double(call: true) }
      let(:agent) { Agent.new }
      subject { described_class.new(encoded_identifiers: encoded_identifiers, decoder: decoder, converter: converter) }

      include Cogitate::RSpecMatchers

      its(:default_converter) { should respond_to(:call) }
      its(:default_decoder) { should respond_to(:call) }

      context '.call' do
        it 'will return an array of Agent objects' do
          decoder_response.each do |identifier|
            expect(converter).to receive(:call).with(identifier: identifier).and_return(agent)
          end
          expect(subject.call).to contractually_honor(Cogitate::Interfaces::AgentCollectionInterface)
        end
      end
    end
  end
end
