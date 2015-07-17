require 'spec_fast_helper'
require 'agent_visitor'

RSpec.describe AgentVisitor do
  let(:agent_builder) { double(add_identity: [], add_verified_authentication_vector: []) }
  subject { described_class.new(agent_builder: agent_builder) }

  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::VisitorInterface) }
  its(:default_agent_builder) { should contractually_honor(Cogitate::Interfaces::AgentBuilderInterface) }

  it { expect(described_class.new).to contractually_honor(Cogitate::Interfaces::VisitorInterface) }

  context '.visit' do
    let(:node1) { double }
    let(:node2) { double }

    it 'will yield the agent if the node has not yet been visited' do
      expect { |b| subject.visit(node1, &b) }.to yield_with_args(agent_builder)
      expect { |b| subject.visit(node1, &b) }.to_not yield_control

      # And now we are visiting another node
      expect { |b| subject.visit(node2, &b) }.to yield_with_args(agent_builder)
    end
  end
end

RSpec.describe AgentVisitor::Builder do
  let(:agent) { double(identities: [], verified_authentication_vectors: []) }
  subject { described_class.new(agent: agent) }
  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::AgentBuilderInterface) }
  its(:default_agent) { should contractually_honor(Cogitate::Interfaces::AgentInterface) }

  context '#add_identity' do
    it 'will update the given agent' do
      expect { subject.add_identity(1) }.to change(agent, :identities).to([1])
    end
  end
  context '#add_verified_authentication_vector' do
    it 'will update the given agent' do
      expect { subject.add_verified_authentication_vector(1) }.to change(agent, :verified_authentication_vectors).to([1])
    end
  end
end
