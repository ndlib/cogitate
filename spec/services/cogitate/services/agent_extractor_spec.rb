require 'spec_fast_helper'
require 'cogitate/services/agent_extractor'
require 'cogitate/parameters/identifier'

module Cogitate
  module Services
    RSpec.describe AgentExtractor do
      before do
        module AgentExtractor
          class MockStrategy
            def initialize(identifier:)
              @identifier = identifier
            end

            def call
            end
          end
        end
      end
      after do
        # Because autoload doesn't like me removing "live" modules
        described_class.send(:remove_const, :MockStrategy)
      end
      let(:identifier) { Parameters::Identifier.new(strategy: 'mock', identifying_value: 'hello') }

      it 'will find the strategy by name convention' do
        expect_any_instance_of(described_class::MockStrategy).to receive(:call)
        described_class.call(identifier: identifier)
      end
    end
  end
end
