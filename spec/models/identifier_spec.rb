require 'spec_fast_helper'
require 'identifier'

RSpec.describe Identifier do
  subject { described_class.new(strategy: 'orcid', identifying_value: '1234') }
  it 'will implement Cogitate::Interfaces::IdentifierInterface' do
    Contract.valid?(subject, Cogitate::Interfaces::IdentifierInterface)
  end

  context '#strategy coercion' do
    [
      ['orcid', 'orcid'],
      [:orcid, 'orcid'],
      ['Orcid', 'orcid']
    ].each do |given, expected|
      it "will coerce #{given.inspect} to #{expected.inspect}" do
        subject = described_class.new(strategy: given, identifying_value: '1234')
        expect(subject.strategy).to eq(expected)
      end
    end
  end

  context '#<=>' do
    it 'will compare on strategy and identifying_value' do
      a = described_class.new(strategy: 'a', identifying_value: '1234')
      b = described_class.new(strategy: 'a', identifying_value: '1234')
      expect(a <=> b).to eq(0)
    end

    it 'will first compare strategy, ignoring identifying_value' do
      a = described_class.new(strategy: 'a', identifying_value: '1234')
      b = described_class.new(strategy: 'b', identifying_value: '1234')
      expect(a <=> b).to eq(-1)
    end

    it 'will first compare strategy, then identifying_value if strategy matches' do
      a = described_class.new(strategy: 'a', identifying_value: '5')
      b = described_class.new(strategy: 'a', identifying_value: '4')
      expect(a <=> b).to eq(1)
    end
  end
end
