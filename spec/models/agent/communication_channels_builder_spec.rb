require 'spec_fast_helper'
require 'agent/communication_channels_builder'

class Agent
  RSpec.describe CommunicationChannelsBuilder do
    let(:agent) { double('Agent', with_identifiers: [identifier_with_email, identifier], add_email: true) }
    let(:identifier) { double("Identifier") }
    let(:identifier_with_email) { double("Identifier", email: 'test@world.com') }
    subject { described_class.new(agent: agent) }

    it "will expose .call as a convenience method" do
      expect_any_instance_of(described_class).to receive(:call)
      described_class.call(agent: agent)
    end

    context '#call' do
      it "will use the agent's with_identifiers and coerce those into emails" do
        expect(agent).to receive(:add_email).with(identifier_with_email.email)
        subject.call
      end

      it "will return the communication channels builder" do
        expect(subject.call).to eq(subject)
      end
    end
  end
end
