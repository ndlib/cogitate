require 'spec_fast_helper'
require 'cogitate/interfaces'
require 'identifier'
require 'cogitate/services/identifying_host_extractor/parroting_strategy'

module Cogitate
  module Services
    module IdentifyingHostExtractor
      RSpec.describe ParrotingStrategy do
        let(:identifier) { Identifier.new(strategy: 'duck', identifying_value: '123') }
        let(:guest) { double(visit: true) }
        let(:visitor) { double(add_identity: true) }
        before { allow(guest).to receive(:visit).with(identifier).and_yield(visitor) }

        include Cogitate::RSpecMatchers
        context '.call' do
          subject { described_class.call(identifier: identifier) }
          it { should contractually_honor(Cogitate::Interfaces::HostInterface) }
        end

        context '#invite' do
          subject { described_class.new(identifier: identifier) }
          it 'will add the identity' do
            expect(visitor).to receive(:add_identity).with(identifier)
            subject.invite(guest)
          end
        end
      end
    end
  end
end
