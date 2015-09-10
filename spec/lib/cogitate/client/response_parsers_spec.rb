require 'spec_fast_helper'
require 'cogitate/client/response_parsers'

RSpec.describe Cogitate::Client::ResponseParsers do
  it 'will find a registered response parser' do
    expect(described_class.fetch(:Email)).to eq(described_class::EmailExtractor)
  end

  it 'will return the given parser if it responds to :call' do
    parser = double(call: true)
    expect(described_class.fetch(parser)).to eq(parser)
  end

  it 'will raise an exception' do
    expect { described_class.fetch(:ChickenSalad) }.to raise_error(Cogitate::Client::ResponseParserNotFound)
  end
end
