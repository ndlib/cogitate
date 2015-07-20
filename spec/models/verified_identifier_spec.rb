require 'spec_fast_helper'
require 'shoulda/matchers'
require 'verified_identifier'

module VerifiedIdentifier
  RSpec.describe Netid do
    let(:identifier) { double(strategy: 'netid', identifying_value: '12', :<=> => 0) }
    subject { described_class.new(identifier: identifier, attributes: { first_name: 'A First Name' }) }
    include Cogitate::RSpecMatchers
    it { should contractually_honor(Cogitate::Interfaces::AuthenticationVectorNetidInterface) }
    it { should delegate_method(:strategy).to(:identifier) }
    it { should delegate_method(:<=>).to(:identifier) }
  end
end