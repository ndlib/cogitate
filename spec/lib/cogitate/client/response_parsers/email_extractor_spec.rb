require 'spec_fast_helper'
require 'cogitate/client/response_parsers/email_extractor'

RSpec.describe Cogitate::Client::ResponseParsers::EmailExtractor do
  let(:response) { File.read(File.expand_path('../../../../../fixtures/agents.response.json', __FILE__)) }
  subject { described_class }

  it 'will parse the response from Cogitate mapping the emails to each of the given identifiers' do
    # Yes there is a bit of cognitive dissonance as I'm using a fixture file that is NOT
    # based on the above identifiers
    expect(subject.call(response: response)).to eq("bmV0aWQJc2hpbGwy" => ["shill2@nd.edu"])
  end
end
