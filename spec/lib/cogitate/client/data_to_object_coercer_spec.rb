require 'spec_helper'
require 'cogitate/client/data_to_object_coercer'

module Cogitate
  module Client
    RSpec.describe DataToObjectCoercer do
      subject { described_class }
      its(:default_type_to_builder_map) { should have_key('agent') }
      its(:default_type_to_builder_map) { should have_key('agents') }
      let(:builder) { double(build: true) }

      it 'will map a type: "agents" to an Agent' do
        expect(builder).to receive(:build).and_return(:built)
        expect(described_class.call(data, type_to_builder_map: { 'agents' => builder })).to eq(:built)
      end

      let(:data) { { "type": "agents", "id": "bmV0aWQJaHdvcmxk" } }
    end
  end
end
