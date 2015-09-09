require 'spec_fast_helper'
require 'cogitate/client/response_parsers/data_extractor'

RSpec.describe Cogitate::Client::ResponseParsers::DataExtractor do
  let(:json) { %({"data": "hello"}) }

  context '.call' do
    it 'will return the data' do
      expect(described_class.call(response: json)).to eq('hello')
    end
  end
end
