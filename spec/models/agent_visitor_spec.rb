require 'spec_fast_helper'
require 'agent_visitor'
require 'shoulda/matchers'

RSpec.describe AgentVisitor do
  let(:collector) { double(add_identity: [], add_verified_authentication_vector: []) }
  let(:identity_collector_builder) { ->(**) { collector } }
  subject { described_class.new(identity_collector_builder: identity_collector_builder) }

  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::VisitorInterface) }
  its(:default_identity_collector_builder) do
    should contractually_honor(Contracts::Func[Cogitate::Interfaces::AgentCollectorInitializationInterface])
  end

  it { expect(described_class.new).to contractually_honor(Cogitate::Interfaces::VisitorInterface) }

  context '.visit' do
    let(:node1) { double }
    let(:node2) { double }

    it 'will yield the agent if the node has not yet been visited' do
      expect { |b| subject.visit(node1, &b) }.to yield_with_args(collector)
      expect { |b| subject.visit(node1, &b) }.to_not yield_control

      # And now we are visiting another node
      expect { |b| subject.visit(node2, &b) }.to yield_with_args(collector)
    end
  end
end

RSpec.describe AgentVisitor::Collector do
  let(:agent) { double(identities: [], verified_authentication_vectors: []) }
  let(:visitor) { double(visit: true) }
  subject { described_class.new(visitor: visitor, agent: agent) }
  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::IdentityCollectorInterface) }
  it { should contractually_honor(Cogitate::Interfaces::VisitorInterface) }

  its(:default_agent) { should contractually_honor(Cogitate::Interfaces::AgentInterface) }
  let(:identity) { double(strategy: '', identifying_value: '', :<=> => '') }

  context '#visit' do
    it 'will delegate visit to the visitor' do
      node = 1
      expect(visitor).to receive(:visit).with(node).and_yield(subject)
      expect { |b| subject.visit(node, &b) }.to yield_with_args(subject)
    end
  end

  context '#add_identity' do
    it 'will update the given agent' do
      expect { subject.add_identity(identity) }.to change(agent, :identities).to([identity])
    end
  end
  context '#add_verified_authentication_vector' do
    it 'will update the given agent' do
      expect { subject.add_verified_authentication_vector(identity) }.to change(agent, :verified_authentication_vectors).to([identity])
    end
  end
end
