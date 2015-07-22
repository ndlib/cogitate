require 'spec_fast_helper'
require 'shoulda/matchers'
require 'identifier/unverified'

RSpec.describe Identifier::Unverified do
  let(:identifier) { double('Identifier', strategy: 'netid', identifying_value: '123', :<=> => 0) }
  subject { described_class.new(identifier: identifier) }

  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::VerifiableIdentifierInterface) }
  its(:verified?) { should be_falsey }
  it { should delegate_method(:strategy).to(:identifier) }
  it { should delegate_method(:identifying_value).to(:identifier) }
  it { should delegate_method(:<=>).to(:identifier) }
end
