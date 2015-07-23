require 'spec_fast_helper'
require 'shoulda/matchers'
require 'identifier/verified'

class Identifier
  RSpec.describe Verified::Netid do
    let(:identifier) { double(strategy: 'netid', identifying_value: '12', :<=> => 0) }
    subject { described_class.new(identifier: identifier, attributes: { first_name: 'A First Name' }) }
    include Cogitate::RSpecMatchers
    it { should contractually_honor(Cogitate::Interfaces::AuthenticationVectorNetidInterface) }
    it { should delegate_method(:identifying_value).to(:identifier) }
    it { should delegate_method(:<=>).to(:identifier) }
    its(:first_name) { should eq('A First Name') }
    its(:attribute_keys) { should be_a(Array) }
    its(:strategy) { should eq("verified/#{identifier.strategy}") }

    it 'will not obliterate the given identifier if the attributes have an identifier' do
      subject = described_class.new(identifier: identifier, attributes: { identifier: 'something else' })
      expect(subject.send(:identifier)).to eq(identifier)
    end
  end
end