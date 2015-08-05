require 'spec_fast_helper'
require 'agent/visitor'
require 'shoulda/matchers'
require 'identifier'

class Agent
  RSpec.describe Visitor do
    let(:identifier) { Identifier.new(strategy: 'orcid', identifying_value: '123') }
    subject { described_class.build(identifier: identifier) }

    include Cogitate::RSpecMatchers
    it { should contractually_honor(Cogitate::Interfaces::VisitorInterface) }
    its(:default_identity_collector_builder) do
      should contractually_honor(Contracts::Func[Cogitate::Interfaces::AgentCollectorInitializationInterface])
    end

    it { expect(described_class.build(identifier: identifier)).to contractually_honor(Cogitate::Interfaces::VisitorInterface) }

    context '.visit' do
      let(:node1) { double }
      let(:node2) { double }

      it 'will yield the agent if the node has not yet been visited' do
        expect { |b| subject.visit(node1, &b) }.to yield_with_args(kind_of(Agent::Collector))
        expect { |b| subject.visit(node1, &b) }.to_not yield_control

        # And now we are visiting another node
        expect { |b| subject.visit(node2, &b) }.to yield_with_args(kind_of(Agent::Collector))
      end

      its(:return_from_visitations) { should contractually_honor(Cogitate::Interfaces::AgentInterface) }
    end
  end

  RSpec.describe Collector do
    let(:agent) { double(identities: [], verified_identities: []) }
    let(:visitor) { double(visit: true) }
    subject { described_class.new(visitor: visitor, agent: agent) }
    include Cogitate::RSpecMatchers
    it { should contractually_honor(Cogitate::Interfaces::IdentityCollectorInterface) }
    it { should contractually_honor(Cogitate::Interfaces::VisitorInterface) }

    let(:identity) { Identifier.new(strategy: '', identifying_value: '') }

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
    context '#add_verified_identifier' do
      it 'will update the given agent' do
        expect { subject.add_verified_identifier(identity) }.to change(agent, :verified_identities).to([identity])
      end
    end
  end
end
