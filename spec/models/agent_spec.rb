require 'spec_fast_helper'
require 'agent'
require 'identifier'
require 'shoulda/matchers'
require 'base64'

RSpec.describe Agent do
  let(:identifier) { Identifier.new(strategy: 'orcid', identifying_value: '123') }
  subject { Agent.new(identifier: identifier) }

  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::AgentInterface) }

  its(:identities) { should be_a(Set) }
  its(:primary_identifier) { should eq(identifier) }
  its(:verified_authentication_vectors) { should be_a(Set) }

  it { should delegate_method(:strategy).to(:primary_identifier) }
  it { should delegate_method(:identifying_value).to(:primary_identifier) }
  it { should delegate_method(:as_json).to(:serializer) }

  its(:type) { should eq(described_class::JSON_API_TYPE) }

  it 'will have a URL Safe Base64 encoded ID' do
    expect { Base64.urlsafe_decode64(subject.id) }.to_not raise_error
  end
end
