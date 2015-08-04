require 'spec_fast_helper'
require 'identifier'
require 'shoulda/matchers'
require 'identifier/verified/netid'

class Identifier
  module Verified
    RSpec.describe Netid do
      let(:identifier) { Identifier.new(strategy: 'netid', identifying_value: '12') }
      subject { described_class.new(identifier: identifier, attributes: { first_name: 'A First Name' }) }
      include Cogitate::RSpecMatchers
      it { should contractually_honor(Cogitate::Interfaces::AuthenticationVectorNetidInterface) }
      it { should delegate_method(:identifying_value).to(:identifier) }
      it { should delegate_method(:<=>).to(:identifier) }
      it { should delegate_method(:base_identifying_value).to(:identifier) }
      it { should delegate_method(:base_strategy).to(:identifier) }
      its(:first_name) { should eq('A First Name') }
      its(:attribute_keys) { should be_a(Array) }
      its(:strategy) { should eq("verified/#{identifier.strategy}") }

      it 'will not obliterate the given identifier if the attributes have an identifier' do
        subject = described_class.new(identifier: identifier, attributes: { identifier: 'something else' })
        expect(subject.send(:identifier)).to eq(identifier)
      end
    end
  end
end
