require 'spec_fast_helper'
require 'cogitate/client/identifier_builder'

RSpec.describe Cogitate::Client::IdentifierBuilder do
  # See the end of the file for :data declaration
  let(:encoded_identifier) { "bmV0aWQJaHdvcmxk" }
  context 'with included information' do
    subject { described_class.call(encoded_identifier: encoded_identifier, included: included) }
    its(:encoded_id) { should eq(encoded_identifier) }
    its(:strategy) { should eq('netid') }
    its(:identifying_value) { should eq('hworld') }
    its(:first_name) { should eq('Hello') }
    its(:last_name) { should eq('World') }
    its(:netid) { should eq('hworld') }

    let(:included) do
      [{
        "type" => "identifiers",
        "id" => "bmV0aWQJaHdvcmxk",
        "attributes" => {
          "identifying_value" => "hworld",
          "strategy" => "netid",
          "first_name" => "Hello",
          "last_name" => "World",
          "netid" => "hworld",
          "full_name" => "Hello World",
          "ndguid" => "nd.edu.hworld",
          "email" => "hworld@nd.edu"
        }
      }]
    end
  end

  context 'with included information' do
    subject { described_class.call(encoded_identifier: encoded_identifier, included: []) }
    its(:encoded_id) { should eq(encoded_identifier) }
    its(:strategy) { should eq('netid') }
    its(:identifying_value) { should eq('hworld') }
    it { should_not respond_to(:first_name) }
    it { should_not respond_to(:last_name) }
    it { should_not respond_to(:netid) }
  end
end
