require 'spec_fast_helper'
require "cogitate/models/identifier"
require 'shoulda/matchers'
require 'cogitate/models/identifiers/verified'

module Cogitate
  module Models
    module Identifiers
      module Verified
        RSpec.describe '.build_named_strategy' do
          before do
            Example = Verified.build_named_strategy('first_name', 'last_name') do
              def foo
                'bar'
              end
            end

            ExampleWithNameAttribute = Verified.build_named_strategy('name')
            ExampleWithNameMethod = Verified.build_named_strategy('other') do
              def name
                'a name'
              end
            end
          end

          after do
            Verified.send(:remove_const, :Example)
            Verified.send(:remove_const, :ExampleWithNameAttribute)
            Verified.send(:remove_const, :ExampleWithNameMethod)
          end

          let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: '12') }
          subject { Example.new(identifier: identifier, attributes: { first_name: 'A First Name' }) }
          it { should delegate_method(:identifying_value).to(:identifier) }

          include Cogitate::RSpecMatchers
          it { should contractually_honor Cogitate::Interfaces::IdentifierInterface }

          it { should delegate_method(:<=>).to(:identifier) }
          it { should delegate_method(:strategy).to(:identifier) }
          it { should delegate_method(:id).to(:identifier) }
          it { should delegate_method(:encoded_id).to(:identifier) }
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

          context '#name' do
            it 'will not obliterate the name attribute if one is given' do
              subject = ExampleWithNameAttribute.new(identifier: identifier, attributes: { name: 'another name' })
              expect(subject.name).to eq('another name')
            end

            it 'will not obliterate the name method if one is given' do
              subject = ExampleWithNameMethod.new(identifier: identifier, attributes: {})
              expect(subject.name).to eq('a name')
            end
          end
        end
      end
    end
  end
end
