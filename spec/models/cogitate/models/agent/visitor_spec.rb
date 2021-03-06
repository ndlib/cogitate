require 'spec_fast_helper'
require 'cogitate/models/agent/visitor'
require 'shoulda/matchers'
require "cogitate/models/identifier"

RSpec.describe Cogitate::Models::Agent::Visitor do
  let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'orcid', identifying_value: '123') }
  let(:communication_channels_builder) { double('Communication Channels Builder', call: true) }
  subject { described_class.build(identifier: identifier, communication_channels_builder: communication_channels_builder) }

  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::VisitorInterface) }
  its(:default_communication_channels_builder) { should respond_to(:call) }

  it { should delegate_method(:add_identifier).to(:agent) }
  it { should delegate_method(:add_identifier).to(:agent) }
  it { should delegate_method(:add_verified_identifier).to(:agent) }

  its(:default_communication_channels_builder) { should respond_to(:call) }

  it { expect(described_class.build(identifier: identifier)).to contractually_honor(Cogitate::Interfaces::VisitorInterface) }

  context '.visit' do
    let(:node1) { double }
    let(:node2) { double }

    it 'will yield the agent if the node has not yet been visited' do
      expect { |b| subject.visit(node1, &b) }.to yield_with_args(subject)
      expect { |b| subject.visit(node1, &b) }.to_not yield_control

      # And now we are visiting another node
      expect { |b| subject.visit(node2, &b) }.to yield_with_args(subject)
    end
  end

  context '#return_from_visitations' do
    it 'should return an Agent' do
      expect(subject.return_from_visitations).to contractually_honor(Cogitate::Interfaces::AgentInterface)
    end
    it 'will finalize the communication channels for the agent' do
      expect(communication_channels_builder).to receive(:call).with(agent: kind_of(Cogitate::Models::Agent))
      subject.return_from_visitations
    end
  end
end
