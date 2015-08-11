require 'spec_fast_helper'
require 'cogitate/client/data_to_object_coercer'

module Cogitate
  module Client
    RSpec.describe DataToObjectCoercer do
      subject { described_class }
      its(:default_type_to_builder_map) { should have_key('agent') }
      its(:default_type_to_builder_map) { should have_key('agents') }
      let(:builder) { double('Builder', call: true) }

      it 'will map a type: "agents" to an Agent' do
        expect(builder).to receive(:call).and_return(:built)
        expect(described_class.call(data, type_to_builder_map: { 'agents' => builder })).to eq(:built)
      end

      it "will fail with a KeyError if the data's type does not exist in the map" do
        expect { described_class.call(data, type_to_builder_map: { 'shoe' => builder }) }.to raise_error(KeyError)
      end

      let(:data) { { "type" => "agents", "id" => "bmV0aWQJaHdvcmxk" } }

      context '.default_type_to_builder_map' do
        it 'will have all elements that respond_to :call' do
          expect(described_class.send(:default_type_to_builder_map).all? { |(_, builder)| builder.respond_to?(:call) }).to be_truthy
        end
      end
    end
  end
end
