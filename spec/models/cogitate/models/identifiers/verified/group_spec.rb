require 'spec_fast_helper'
require "cogitate/models/identifier"
require 'shoulda/matchers'
require 'cogitate/models/identifiers/verified/group'

RSpec.describe Cogitate::Models::Identifiers::Verified::Group do
  let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'group', identifying_value: '12') }
  subject { described_class.new(identifier: identifier, attributes: { name: 'A Group Name' }) }
  include Cogitate::RSpecMatchers
  it { should contractually_honor Cogitate::Interfaces::IdentifierInterface }
  it { should contractually_honor(Cogitate::Interfaces::VerifiedGroupInterface) }
  it { should delegate_method(:identifying_value).to(:identifier) }
  it { should delegate_method(:<=>).to(:identifier) }
  it { should delegate_method(:strategy).to(:identifier) }
  its(:name) { should eq('A Group Name') }
  its(:as_json) { should eq('strategy' => 'group', 'identifying_value' => '12', 'name' => 'A Group Name', 'description' => nil) }

  it 'will not obliterate the given identifier if the attributes have an identifier' do
    subject = described_class.new(identifier: identifier, attributes: { identifier: 'something else' })
    expect(subject.send(:identifier)).to eq(identifier)
  end
end
