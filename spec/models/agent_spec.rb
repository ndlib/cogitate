require 'spec_fast_helper'
require 'cogitate/interfaces'
require 'agent'

RSpec.describe Agent do
  subject { Agent.new }

  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::AgentInterface) }

  its(:identities) { should be_a(Set) }
  its(:verified_authentication_vectors) { should be_a(Set) }
end
