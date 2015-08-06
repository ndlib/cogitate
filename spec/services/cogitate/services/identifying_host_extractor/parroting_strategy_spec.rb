require 'spec_fast_helper'
require 'cogitate/interfaces'
require 'identifier'
require 'identifier/unverified'
require 'cogitate/services/identifying_host_extractor/parroting_strategy'

module Cogitate
  module Services
    module IdentifyingHostExtractor
      RSpec.describe ParrotingStrategy do
        let(:identifier) { Identifier.new(strategy: 'duck', identifying_value: '123') }
        let(:guest) { double(visit: true) }
        let(:visitor) { double(add_identifier: true) }
        before { allow(guest).to receive(:visit).and_yield(visitor) }

        subject { described_class.call(identifier: identifier) }

        its(:identifier) { should be_a(Identifier::Unverified) }

        context '.call' do
          include Cogitate::RSpecMatchers
          it { should contractually_honor(Cogitate::Interfaces::HostInterface) }
        end

        context '#invite' do
          it 'will add the identity' do
            expect(visitor).to receive(:add_identifier).with(kind_of(Identifier::Unverified))
            subject.invite(guest)
          end
        end
      end
    end
  end
end
