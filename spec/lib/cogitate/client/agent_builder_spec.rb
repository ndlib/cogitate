require 'spec_fast_helper'
require 'cogitate/client/agent_builder'

module Cogitate
  module Client
    RSpec.describe AgentBuilder do
      subject { described_class.new(data) }

      its(:default_identifier_builder) { should respond_to(:call) }
      its(:default_agent_builder) { should respond_to(:call) }

      it 'will expose .call as the public api' do
        expect_any_instance_of(described_class).to receive(:call)
        described_class.call(data)
      end

      it 'will raise a KeyError if the data is not well formed' do
        expect { described_class.call({}) }.to raise_error(KeyError)
      end

      context '#call' do
        let(:agent) { Cogitate::Models::Agent.build_with_identifying_information(strategy: 'netid', identifying_value: 'hworld') }
        let(:agent_builder) { ->(*) { agent } }
        subject { described_class.new(data, agent_builder: agent_builder, identifier_guard: identifier_guard) }
        context 'with a guard that allows everything' do
          let(:identifier_guard) { double(call: true) }
          before { subject.call }
          its(:call) { should be_a(Cogitate::Models::Agent) }
          it 'will extract and assign emails to the agent' do
            expect(agent.with_emails.to_a).to eq(['hworld@nd.edu'])
          end
          it 'will extract and assign identifiers to the agent' do
            expect(agent.with_identifiers.to_a.map(&:encoded_id)).to eq(['bmV0aWQJaHdvcmxk'])
          end
          it 'will extract and assign verified_identifiers to the agent' do
            expect(agent.with_identifiers.to_a.map(&:encoded_id)).to eq(['bmV0aWQJaHdvcmxk'])
          end
        end

        context 'with a guard that does not allow anything' do
          let(:identifier_guard) { double(call: false) }
          before { subject.call }
          it 'will extract and assign emails to the agent' do
            expect(agent.with_emails.to_a).to eq([])
          end
          it 'will extract and assign identifiers to the agent' do
            expect(agent.with_identifiers.to_a).to eq([])
          end
          it 'will extract and assign verified_identifiers to the agent' do
            expect(agent.with_verified_identifiers.to_a).to eq([])
          end
        end
      end

      context '#call result (without dependency injection)' do
        subject { described_class.new(data).call }
        its(:strategy) { should eq('netid') }
        its(:identifying_value) { should eq('hworld') }
        context '#with_emails' do
          it 'will be an Enumerator with one email' do
            expect(subject.with_emails.to_a).to eq(['hworld@nd.edu'])
          end
        end

        context '#with_identifiers' do
          it 'will have attributes' do
            expect(subject.with_identifiers.to_a.first.attributes).to eq(data.fetch('included').first.fetch('attributes'))
          end
        end
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
