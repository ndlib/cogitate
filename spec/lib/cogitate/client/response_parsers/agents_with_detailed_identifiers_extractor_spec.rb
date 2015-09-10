require 'spec_fast_helper'
require 'cogitate/client/response_parsers/agents_with_detailed_identifiers_extractor'

RSpec.describe Cogitate::Client::ResponseParsers::AgentsWithDetailedIdentifiersExtractor do
  let(:json) { FixtureFile.read('group_and_netid_identifiers_in_one_response.json') }
  subject { described_class.call(response: json) }

  it 'will call DataToObjectCoercer for each datum' do
    expect(Cogitate::Client::DataToObjectCoercer).to receive(:call).exactly(2).times
    described_class.call(response: json)
  end

  it 'will expose the base id' do
    expect(subject.map(&:id).sort).to eq(["Z3JvdXAJR3JhZHVhdGUgU2Nob29sIEVURCBSZXZpZXdlcnM=", "bmV0aWQJamZyaWVzZW4="].sort)
  end
end
