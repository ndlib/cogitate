require 'spec_fast_helper'
require 'cogitate/parameters/identifier'
require 'cogitate/services/identifying_host_extractor'

module Cogitate
  module Services
    RSpec.describe IdentifyingHostExtractor do
      before do
        module IdentifyingHostExtractor
          class MockStrategy
            def self.call(identifier:)
              identifier
            end
          end
        end
      end
      after do
        # Because autoload doesn't like me removing "live" modules
        described_class.send(:remove_const, :MockStrategy)
      end
      let(:identifier) { Parameters::Identifier.new(strategy: 'mock', identifying_value: 'hello') }
      let(:host) { double('Host', invite: true) }
      let(:visitor) { double(visit: true) }

      context '.call' do
        it 'will find the correct host the invite the visitor and return the visitor' do
          expect(described_class::MockStrategy).to receive(:call).and_return(host)
          expect(host).to receive(:invite).with(visitor)
          described_class.call(identifier: identifier, visitor: visitor)
        end
      end

      context '.identifying_host_for' do
        it 'will find the correct container and call it' do
          expect(described_class::MockStrategy).to receive(:call).and_return(host)
          described_class.identifying_host_for(identifier: identifier)
        end
      end
    end
  end
end
