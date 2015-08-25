require 'spec_fast_helper'
require 'cogitate/client'

RSpec.describe Cogitate::Client do
  context '.encoded_identifier_for' do
    it 'should return a string' do
      expect(described_class.encoded_identifier_for(strategy: 'netid', identifying_value: 'hworld')).to be_a(String)
    end
  end
end
