require 'spec_fast_helper'
require "cogitate/models/identifier"
require 'shoulda/matchers'
require 'identifier/verified'

class Identifier
  module Verified
    RSpec.describe '.build_named_strategy' do
      before do
        Example = Verified.build_named_strategy('first_name', 'last_name') do
          def foo
            'bar'
          end
        end
      end

      after do
        Verified.send(:remove_const, :Example)
      end

      let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: '12') }
      subject { Example.new(identifier: identifier, attributes: { first_name: 'A First Name' }) }
      it { should delegate_method(:identifying_value).to(:identifier) }

      it { should delegate_method(:<=>).to(:identifier) }
      it { should delegate_method(:strategy).to(:identifier) }
      its(:first_name) { should eq('A First Name') }
      its(:attribute_keys) { should eq(['first_name', 'last_name']) }
      its(:foo) { should eq('bar') }
      its(:as_json) do
        should eq(
          'identifying_value' => identifier.identifying_value, 'strategy' => identifier.strategy,
          'first_name' => "A First Name", 'last_name' => nil
        )
      end

      it 'will not obliterate the given identifier if the attributes have an identifier' do
        subject = Example.new(identifier: identifier, attributes: { identifier: 'something else' })
        expect(subject.send(:identifier)).to eq(identifier)
      end
    end
  end
end
