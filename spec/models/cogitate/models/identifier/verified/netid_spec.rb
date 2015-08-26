require 'spec_fast_helper'
require "cogitate/models/identifier"
require 'shoulda/matchers'
require 'cogitate/models/identifier/verified/netid'

RSpec.describe Cogitate::Models::Identifier::Verified::Netid do
  let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: '12') }
  subject do
    described_class.new(
      identifier: identifier, attributes: { first_name: 'First', last_name: 'Last', netid: 'hello', full_name: 'First Last' }
    )
  end
  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::AuthenticationVectorNetidInterface) }
  it { should delegate_method(:identifying_value).to(:identifier) }
  it { should delegate_method(:<=>).to(:identifier) }
  it { should delegate_method(:strategy).to(:identifier) }
  it { should delegate_method(:encoded_id).to(:identifier) }
  its(:first_name) { should eq('First') }
  its(:attribute_keys) { should be_a(Array) }
  its(:as_json) { should be_a(Hash) }
  its(:attribute_keys) { should include('email') }
  its(:attribute_keys) { should include('netid') }
  its(:attribute_keys) { should include('full_name') }

  its(:email) { should eq('hello@nd.edu') }
  its(:name) { should eq('First Last') }

  it 'will not obliterate the given identifier if the attributes have an identifier' do
    subject = described_class.new(identifier: identifier, attributes: { identifier: 'something else' })
    expect(subject.send(:identifier)).to eq(identifier)
  end

  context '#name' do
    it 'will default to #full_name' do
      subject = described_class.new(
        identifier: identifier, attributes: { first_name: "F", last_name: "L", netid: 'hello', full_name: 'FN' }
      )
      expect(subject.name).to eq(subject.full_name)
    end
    it 'will fallback to #first_name and #last_name if #full_name is not set' do
      subject = described_class.new(identifier: identifier, attributes: { first_name: "F", last_name: "L", netid: 'hello' })
      expect(subject.name).to eq('F L')
    end
    it 'will fallback to #netid if #first_name, #last_name, and #full_name are not set' do
      subject = described_class.new(identifier: identifier, attributes: { netid: 'hello' })
      expect(subject.name).to eq('hello')
    end
  end
end
