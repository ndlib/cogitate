require 'spec_fast_helper'
require "cogitate/models/identifier"
require 'shoulda/matchers'
require 'cogitate/models/identifier/verified/netid'

RSpec.describe Cogitate::Models::Identifier::Verified::Netid do
  let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: '12') }
  subject { described_class.new(identifier: identifier, attributes: { first_name: 'A First Name', netid: 'hello' }) }
  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::AuthenticationVectorNetidInterface) }
  it { should delegate_method(:identifying_value).to(:identifier) }
  it { should delegate_method(:<=>).to(:identifier) }
  it { should delegate_method(:strategy).to(:identifier) }
  it { should delegate_method(:encoded_id).to(:identifier) }
  its(:first_name) { should eq('A First Name') }
  its(:attribute_keys) { should be_a(Array) }
  its(:as_json) { should be_a(Hash) }
  its(:attribute_keys) { should include('email') }
  its(:attribute_keys) { should include('netid') }
  its(:attribute_keys) { should include('full_name') }

  its(:email) { should eq('hello@nd.edu') }

  it 'will not obliterate the given identifier if the attributes have an identifier' do
    subject = described_class.new(identifier: identifier, attributes: { identifier: 'something else' })
    expect(subject.send(:identifier)).to eq(identifier)
  end
end