require 'spec_fast_helper'
require 'cogitate/client/agent_builder'

module Cogitate
  module Client
    RSpec.describe AgentBuilder do
      it 'will convert the data into an Agent' do
        agent = described_class.call(data)
        expect(agent.encoded_id).to eq(data.fetch('id'))
        expect(agent.with_emails.to_a).to eq(['hworld@nd.edu'])
        expect(agent.with_identifiers.to_a.map(&:encoded_id)).to eq(['bmV0aWQJaHdvcmxk'])
        expect(agent.with_verified_identifiers.to_a.map(&:encoded_id)).to eq(['bmV0aWQJaHdvcmxk'])
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
