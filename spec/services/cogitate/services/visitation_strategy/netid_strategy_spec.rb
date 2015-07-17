require 'cogitate/services/visitation_strategy/netid_strategy'

module Cogitate
  module Services
    module VisitationStrategy
      module NetidStrategy
        RSpec.describe Verified do
          let(:identifier) { double(strategy: 'netid', identifying_value: '1234') }
          let(:visitor) { double(visit: true) }
          let(:agent) { double(add_identity: true, add_verified_authentication_vector: true) }
          subject { described_class.new(identifier: identifier) }
          before { allow(visitor).to receive(:visit).and_yield(agent) }

          context '#invite a visitor' do
            it 'will add the identity to the agent builder' do
              expect(agent).to receive(:add_identity).with(identifier)
              subject.invite(visitor)
            end
            it 'will add to the verified_authentication_vectors of the agent builder' do
              expect(agent).to receive(:add_verified_authentication_vector).with(identifier)
              subject.invite(visitor)
            end
          end
        end

        RSpec.describe Unverified do
          let(:identifier) { double(strategy: 'netid', identifying_value: '1234') }
          let(:visitor) { double(visit: true) }
          let(:agent) { double(add_identity: true, add_verified_authentication_vector: true) }
          subject { described_class.new(identifier: identifier) }
          before { allow(visitor).to receive(:visit).and_yield(agent) }

          context '#invite a visitor' do
            it 'will add the identity to the agent builder' do
              expect(agent).to receive(:add_identity).with(identifier)
              subject.invite(visitor)
            end
            it 'will NOT dd to the verified_authentication_vectors of the agent builder' do
              expect(agent).to_not receive(:add_verified_authentication_vector).with(identifier)
              subject.invite(visitor)
            end
          end
        end
      end
    end
  end
end
