require 'spec_fast_helper'
require 'cogitate/models/identifier'
require 'cogitate/models/identifiers/with_attribute_hash'
require 'shoulda/matchers'

RSpec.describe Cogitate::Models::Identifiers::WithAttributeHash do
  let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: 'hworld') }
  let(:attributes) { { 'first_name' => 'A First Name' } }
  subject { described_class.new(identifier: identifier, attributes: attributes) }

  Cogitate::Models::Identifier.interface_method_names.each do |method_name|
    it { should delegate_method(method_name).to(:identifier) }
  end

  its(:attributes) { should eq('first_name' => 'A First Name') }
  its(:first_name) { should eq('A First Name') }
  its(:as_json) { should eq('strategy' => 'netid', 'identifying_value' => 'hworld', 'first_name' => 'A First Name') }
end
