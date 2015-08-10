require 'spec_fast_helper'
require 'identifier'
require 'shoulda/matchers'
require 'identifier/verified/group'

class Identifier
  module Verified
    RSpec.describe Group do
      let(:identifier) { Identifier.new(strategy: 'group', identifying_value: '12') }
      subject { described_class.new(identifier: identifier, attributes: { name: 'A Group Name' }) }
      include Cogitate::RSpecMatchers
      it { should contractually_honor(Cogitate::Interfaces::VerifiedGroupInterface) }
      it { should delegate_method(:identifying_value).to(:identifier) }
      it { should delegate_method(:<=>).to(:identifier) }
      it { should delegate_method(:base_identifying_value).to(:identifier) }
      it { should delegate_method(:base_strategy).to(:identifier) }
      it { should delegate_method(:strategy).to(:identifier) }
      its(:name) { should eq('A Group Name') }
      its(:as_json) { should eq('name' => 'A Group Name', 'description' => nil) }

      it 'will not obliterate the given identifier if the attributes have an identifier' do
        subject = described_class.new(identifier: identifier, attributes: { identifier: 'something else' })
        expect(subject.send(:identifier)).to eq(identifier)
      end
    end
  end
end
