require 'spec_fast_helper'
require 'agent_visitor'

RSpec.describe AgentVisitor do
  let(:agent) { double(identities: [], verified_authentication_vectors: []) }
  subject { described_class.new(agent: agent) }

  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::VisitorInterface) }

  it { expect(described_class.new).to contractually_honor(Cogitate::Interfaces::VisitorInterface) }

  context '.visit' do
    let(:node1) { double }
    let(:node2) { double }

    it 'will yield the agent if the node has not yet been visited' do
      expect { |b| subject.visit(node1, &b) }.to yield_with_args(agent)
      expect { |b| subject.visit(node1, &b) }.to_not yield_control

      # And now we are visiting another node
      expect { |b| subject.visit(node2, &b) }.to yield_with_args(agent)
    end
  end
end
