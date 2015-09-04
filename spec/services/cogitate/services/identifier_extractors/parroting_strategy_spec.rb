require 'spec_fast_helper'
require 'cogitate/interfaces'
require "cogitate/models/identifier"
require 'cogitate/models/identifier/unverified'
require 'cogitate/services/identifier_extractors/parroting_strategy'

module Cogitate
  module Services
    module IdentifierExtractors
      RSpec.describe ParrotingStrategy do
        let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'duck', identifying_value: '123') }
        let(:guest) { double(visit: true) }
        let(:visitor) { double(add_identifier: true) }
        before { allow(guest).to receive(:visit).and_yield(visitor) }

        subject { described_class.call(identifier: identifier) }

        its(:identifier) { should be_a(Cogitate::Models::Identifier::Unverified) }

        context '.call' do
          include Cogitate::RSpecMatchers
          it { should contractually_honor(Cogitate::Interfaces::HostInterface) }
        end

        context '#invite' do
          it 'will add the identity' do
            expect(visitor).to receive(:add_identifier).with(kind_of(Cogitate::Models::Identifier::Unverified))
            subject.invite(guest)
          end
        end
      end
    end
  end
end
