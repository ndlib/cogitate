require 'spec_fast_helper'
require "cogitate/models/identifier"
require 'shoulda/matchers'
require 'cogitate/models/identifiers/unverified'

RSpec.describe Cogitate::Models::Identifiers::Unverified do
  let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: '123') }
  subject { described_class.new(identifier: identifier) }

  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::VerifiableIdentifierInterface) }
  its(:verified?) { should be_falsey }
  its(:as_json) { should eq('identifying_value' => identifier.identifying_value, 'strategy' => identifier.strategy) }
  Cogitate::Models::Identifier.interface_method_names.each do |method_name|
    it { should delegate_method(method_name).to(:identifier) }
  end
end
