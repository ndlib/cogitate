require 'spec_fast_helper'
require 'identifier'
require 'agent'
require 'agent/serializer'
require 'json'

RSpec.describe Agent::Serializer do
  let(:identifier) { Identifier.new(strategy: 'netid', identifying_value: 'hello') }
  let(:agent) { Agent.new(identifier: identifier) }
  subject { described_class.new(agent: agent) }

  its(:to_json) { should be_a(String) }

  context '#as_json' do
    before do
      agent.identities << identifier
      agent.verified_identities << identifier
    end
    it 'will build a json document' do
      json = subject.as_json
      expect(json.fetch('type')).to eq(agent.type)
      expect(json.fetch('id')).to eq(agent.id)
      expect(json.fetch('attributes')).to eq('strategy' => identifier.strategy, 'identifying_value' => identifier.identifying_value)
      expect(json.fetch('relationships').fetch('identities')).to eq([{ "type" => "netid", "id" => "hello", 'attributes' => {} }])
      expect(json.fetch('relationships').fetch('verified_identities')).to eq([{ "type" => "netid", "id" => "hello", 'attributes' => {} }])
    end
  end
end
