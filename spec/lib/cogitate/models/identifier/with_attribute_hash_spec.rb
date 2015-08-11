require 'spec_fast_helper'
require 'cogitate/models/identifier'
require 'cogitate/models/identifier/with_attribute_hash'
require 'shoulda/matchers'

RSpec.describe Cogitate::Models::Identifier::WithAttributeHash do
  let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: 'hworld') }
  let(:attributes) { { 'first_name' => 'A First Name' } }
  subject { described_class.new(identifier: identifier, attributes: attributes) }
  it { should delegate_method(:encoded_id).to(:identifier) }
  it { should delegate_method(:<=>).to(:identifier) }
  it { should delegate_method(:identifying_value).to(:identifier) }
  it { should delegate_method(:strategy).to(:identifier) }

  its(:attributes) { should eq('first_name' => 'A First Name') }
  its(:first_name) { should eq('A First Name') }
  its(:as_json) { should eq('strategy' => 'netid', 'identifying_value' => 'hworld', 'first_name' => 'A First Name') }
end
