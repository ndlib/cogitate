require 'spec_fast_helper'
require 'cogitate/client/agent_builder'

module Cogitate
  module Client
    RSpec.describe AgentBuilder do
      subject { described_class.new(data) }

      its(:default_identifier_builder) { should respond_to(:call) }

      it 'will expose .call as the public api' do
        expect_any_instance_of(described_class).to receive(:call)
        described_class.call(data)
      end

      it 'will raise a KeyError if the data is not well formed' do
        expect { described_class.call({}) }.to raise_error(KeyError)
      end

      context '#call' do
        let(:identifier_builder) { double('IdentifierBuilder', call: true) }
        let(:agent_identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: 'hworld') }
        subject { described_class.new(data, identifier_builder: identifier_builder) }
        let(:agent) { subject.call }
        before do
          allow(identifier_builder).to receive(:call).with(encoded_identifier: "bmV0aWQJaHdvcmxk").and_return(agent_identifier)
          allow(identifier_builder).to receive(:call).with(encoded_identifier: "bmV0aWQJaHdvcmxk", included: data.fetch('included')).
            and_return(agent_identifier)
        end
        it 'will extract and assign emails to the agent' do
          expect(agent.with_emails.to_a).to eq(['hworld@nd.edu'])
        end
        it 'will extract and assign identifiers to the agent' do
          expect(agent.with_identifiers.to_a).to eq([agent_identifier])
        end
        it 'will extract and assign verified_identifiers to the agent' do
          expect(agent.with_verified_identifiers.to_a).to eq([agent_identifier])
        end
        its(:call) { should be_a(Cogitate::Models::Agent) }
      end

      let(:data) do
        {
          "type" => "agents",
          "id" => "bmV0aWQJaHdvcmxk",
          "links" => {
            "self" => "http://localhost:3000/api/agents/bmV0aWQJaHdvcmxk"
          },
          "attributes" => {
            "strategy" => "netid",
            "identifying_value" => "hworld",
            "emails" => ["hworld@nd.edu"]
          },
          "relationships" => {
            "identifiers" => [{
              "type" => "identifiers",
              "id" => "bmV0aWQJaHdvcmxk"
            }],
            "verified_identifiers" => [{
              "type" => "identifiers",
              "id" => "bmV0aWQJaHdvcmxk"
            }]
          },
          "included" => [{
            "type" => "identifiers",
            "id" => "bmV0aWQJaHdvcmxk",
            "attributes" => {
              "identifying_value" => "hworld",
              "strategy" => "netid",
              "first_name" => "Hello",
              "last_name" => "World",
              "netid" => "hworld",
              "full_name" => "Hello World",
              "ndguid" => "nd.edu.hworld",
              "email" => "hworld@nd.edu"
            }
          }]
        }
      end
    end
  end
end
