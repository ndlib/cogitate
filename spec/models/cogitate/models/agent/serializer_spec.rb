require 'spec_fast_helper'
require 'identifier'
require 'cogitate/models/agent/serializer'
require 'json'

RSpec.describe Cogitate::Models::Agent::Serializer do
  let(:identifier) { Identifier.new(strategy: 'netid', identifying_value: 'hello') }
  let(:verified_identifier) { Identifier.new(strategy: 'netid', identifying_value: 'verified') }
  let(:unverified_identifier) { Identifier.new(strategy: 'netid', identifying_value: 'not_verified') }
  let(:agent) { Cogitate::Models::Agent.new(identifier: identifier) }
  subject { described_class.new(agent: agent) }

  its(:to_json) { should be_a(String) }

  context '#as_json' do
    before do
      agent.add_identifier(identifier)
      agent.add_verified_identifier(identifier)
      agent.add_verified_identifier(verified_identifier)
      agent.add_identifier(unverified_identifier)
      agent.add_email('hello@world.com')
    end
    it 'will build a json document' do
      json = subject.as_json
      expect(json.fetch('type')).to eq(subject.send(:type))
      expect(json.fetch('id')).to eq(agent.encoded_id)
      expect(json.fetch('links').fetch('self')).to match(%r{/api/agents/#{agent.encoded_id}})
      expect(json.fetch('attributes')).to eq(
        'strategy' => identifier.strategy, 'identifying_value' => identifier.identifying_value, 'emails' => ['hello@world.com']
      )
      expect(json.fetch('included')).to eq([
        { "type" => "identifiers", "id" => identifier.encoded_id, "attributes" => identifier.as_json },
        { "type" => "identifiers", "id" => unverified_identifier.encoded_id, "attributes" => unverified_identifier.as_json },
        { "type" => "identifiers", "id" => verified_identifier.encoded_id, "attributes" => verified_identifier.as_json }
      ])
      expect(json.fetch('relationships').fetch('identifiers')).to eq([
        { "type" => "identifiers", "id" => identifier.encoded_id },
        { "type" => "identifiers", "id" => unverified_identifier.encoded_id }
      ])
      expect(json.fetch('relationships').fetch('verified_identifiers')).to eq([
        { "type" => "identifiers", "id" => identifier.encoded_id },
        { "type" => "identifiers", "id" => verified_identifier.encoded_id }
      ])
    end
  end
end
