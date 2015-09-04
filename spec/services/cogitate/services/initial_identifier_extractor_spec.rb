require 'spec_fast_helper'
require "cogitate/models/identifier"
require 'cogitate/services/initial_identifier_extractor'

module Cogitate
  module Services
    RSpec.describe InitialIdentifierExtractor do
      before do
        module InitialIdentifierExtractor
          class MockStrategy
            def self.call(identifier:, membership_visitation_service:)
              [identifier, membership_visitation_service]
            end
          end
        end
      end
      after do
        # Because autoload doesn't like me removing "live" modules
        described_class.send(:remove_const, :MockStrategy)
      end
      subject { described_class }
      let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'mock', identifying_value: 'hello') }
      let(:host) { double('Host', invite: true) }
      let(:visitor) { double(visit: true) }
      let(:membership_visitation_service) { double('Membership Visitation Service', call: true) }
      let(:membership_visitation_finder) { double(call: membership_visitation_service) }

      its(:fallback_hosting_strategy) { should respond_to(:call) }
      its(:default_membership_visitation_finder) { should respond_to(:call) }

      context 'with a defined existing strategy' do
        context '.call' do
          it 'will find the correct host the invite the visitor and return the visitor' do
            expect(described_class::MockStrategy).to receive(:call).and_return(host)
            expect(host).to receive(:invite).with(visitor)
            described_class.call(identifier: identifier, visitor: visitor, membership_visitation_finder: membership_visitation_finder)
          end
        end

        context '.identifying_host_for' do
          it 'will find the correct container and call it' do
            expect(described_class::MockStrategy).to receive(:call).and_return(host)
            described_class.identifying_host_for(
              identifier: identifier, visitation_type: :first, membership_visitation_finder: membership_visitation_finder
            )
          end
        end
      end

      context 'with a missing strategy' do
        let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'like_this_totally_does_not_exist', identifying_value: 'hello') }

        context '.call' do
          it 'will find the correct host the invite the visitor and return the visitor' do
            expect(described_class::ParrotingStrategy).to receive(:call).and_return(host)
            expect(host).to receive(:invite).with(visitor)
            described_class.call(identifier: identifier, visitor: visitor)
          end
        end

        context '.identifying_host_for' do
          it 'will fallback to the parrot strategy' do
            expect(described_class::ParrotingStrategy).to receive(:call).and_return(host)
            described_class.identifying_host_for(
              identifier: identifier, visitation_type: :knuckles, membership_visitation_finder: membership_visitation_finder
            )
          end
        end
      end
    end
  end
end
