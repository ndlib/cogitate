require 'spec_fast_helper'
require 'cogitate/models/agent/with_token'
require 'cogitate/models/agent'
require 'cogitate/models/identifier'
require 'shoulda/matchers'

RSpec.describe Cogitate::Models::Agent::WithToken do
  let(:token) { 'abcdef' }
  let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: 'hworld') }
  let(:agent) { Cogitate::Models::Agent.new(identifier: identifier) }
  subject { described_class.new(agent: agent, token: token) }
  it { should respond_to(:with_emails) }
  its(:to_token) { should eq(token) }

  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::AgentWithTokenInterface) }
end
