require 'spec_fast_helper'
require 'cogitate/client/response_parsers/agents_without_group_membership_extractor'

RSpec.describe Cogitate::Client::ResponseParsers::AgentsWithoutGroupMembershipExtractor do
  context '.call' do
    let(:json) { FixtureFile.read('group_and_netid_identifiers_in_one_response.json') }
    subject { described_class.call(response: json) }

    it 'will call DataToObjectCoercer for each datum' do
      expect(Cogitate::Client::DataToObjectCoercer).to receive(:call).with(
        kind_of(Hash), identifier_guard: described_class.method(:identifier_is_not_a_group?)
      ).exactly(2).times
      described_class.call(response: json)
    end
  end

  context '.identifier_is_not_a_group?' do
    [
      ['group', false],
      ['Group', false],
      ['a_group', true],
      ['netid', true]
    ].each do |strategy, expected_value|
      it "will be #{expected_value.inspect} for an identifier with strategy == '#{strategy.inspect}'" do
        identifier = Cogitate::Models::Identifier.new(strategy: strategy, identifying_value: 'who cares')
        expect(described_class.identifier_is_not_a_group?(identifier: identifier)).to eq(expected_value)
      end
    end
  end
end
