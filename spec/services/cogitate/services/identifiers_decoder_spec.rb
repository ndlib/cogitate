require 'spec_fast_helper'
require 'cogitate/services/identifiers_decoder'
require 'identifier'
require 'base64'

module Cogitate
  module Services
    RSpec.describe IdentifiersDecoder do
      [
        {
          given: "NETID\tsoup", expected: [Identifier.new(strategy: 'netid', identifying_value: 'soup')]
        }, {
          given: "netid\tsoup", expected: [Identifier.new(strategy: 'netid', identifying_value: 'soup')]
        }, {
          given: "netid\tsoup\nORCID\t0001-0002-0003-0004",
          expected: [
            Identifier.new(strategy: 'netid', identifying_value: 'soup'),
            Identifier.new(strategy: 'orcid', identifying_value: '0001-0002-0003-0004')
          ]
        }, {
          given: "netid\tsoup", expected: [Identifier.new(strategy: 'netid', identifying_value: 'soup')]
        }
      ].each do |scenario_entry|
        it "will convert a Base64 urlsafe encoded #{scenario_entry.fetch(:given).inspect} to #{scenario_entry.fetch(:expected).inspect}" do
          encoded_payload = Base64.urlsafe_encode64(scenario_entry.fetch(:given))
          expect(subject.call(encoded_payload)).to eq(scenario_entry.fetch(:expected))
        end

        it "will not convert a non-urlsafe base Base64 encoded #{scenario_entry[:given].inspect} to #{scenario_entry[:expected].inspect}" do
          encoded_payload = Base64.encode64(scenario_entry.fetch(:given))
          expect { subject.call(encoded_payload) }.to raise_error(described_class::InvalidIdentifierEncoding)
        end
      end

      [
        'hello', "hello\nnetid\tsoup"
      ].each do |invalid_format|
        it "will fail to convert #{invalid_format.inspect}, a properly encoded object but with the wrong format" do
          encoded_payload = Base64.urlsafe_encode64(invalid_format)
          expect { subject.call(encoded_payload) }.to raise_error(described_class::InvalidIdentifierFormat)
        end
      end
    end
  end
end
