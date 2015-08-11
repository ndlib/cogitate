require 'spec_fast_helper'
require "cogitate/models/identifier"
require 'shoulda/matchers'
require 'cogitate/models/identifier/unverified'

RSpec.describe Cogitate::Models::Identifier::Unverified do
  let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: '123') }
  subject { described_class.new(identifier: identifier) }

  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::VerifiableIdentifierInterface) }
  its(:verified?) { should be_falsey }
  its(:as_json) { should eq('identifying_value' => identifier.identifying_value, 'strategy' => identifier.strategy) }
  it { should delegate_method(:identifying_value).to(:identifier) }
  it { should delegate_method(:<=>).to(:identifier) }
  it { should delegate_method(:strategy).to(:identifier) }
  it { should delegate_method(:encoded_id).to(:identifier) }
end
