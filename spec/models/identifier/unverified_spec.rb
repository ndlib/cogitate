require 'spec_fast_helper'
require 'identifier'
require 'shoulda/matchers'
require 'identifier/unverified'

RSpec.describe Identifier::Unverified do
  let(:identifier) { Identifier.new(strategy: 'netid', identifying_value: '123') }
  subject { described_class.new(identifier: identifier) }

  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::VerifiableIdentifierInterface) }
  its(:verified?) { should be_falsey }
  its(:as_json) { should eq({}) }
  it { should delegate_method(:identifying_value).to(:identifier) }
  it { should delegate_method(:<=>).to(:identifier) }
  it { should delegate_method(:base_strategy).to(:identifier) }
  it { should delegate_method(:strategy).to(:identifier) }
  it { should delegate_method(:base_identifying_value).to(:identifier) }
  it { should delegate_method(:encoded_id).to(:identifier) }
end
