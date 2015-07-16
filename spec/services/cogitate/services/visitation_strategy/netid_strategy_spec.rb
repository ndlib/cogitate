require 'cogitate/services/visitation_strategy/netid_strategy'

module Cogitate
  module Services
    module VisitationStrategy
      module NetidStrategy
        RSpec.describe Verified do
          let(:identifier) { double(strategy: 'netid', identifying_value: '1234') }
          let(:visitor) { double(visit: true) }
          let(:agent) { double(identifiers: [], verified_authentication_vectors: []) }
          subject { described_class.new(identifier: identifier) }
          before { allow(visitor).to receive(:visit).and_yield(agent) }

          context '#invite a visitor' do
            it 'will increment the associated #identifiers' do
              expect { subject.invite(visitor) }.to change{ agent.identifiers }.to([identifier])
            end
            it 'will increment the associated #verified_authentication_vectors' do
              expect { subject.invite(visitor) }.to change { agent.verified_authentication_vectors }.to([identifier])
            end
          end
        end

        RSpec.describe Unverified do
          let(:identifier) { double(strategy: 'netid', identifying_value: '1234') }
          let(:visitor) { double(visit: true) }
          let(:agent) { double(identifiers: [], verified_authentication_vectors: []) }
          subject { described_class.new(identifier: identifier) }
          before { allow(visitor).to receive(:visit).and_yield(agent) }

          context '#invite a visitor' do
            it 'will increment the associated #identifiers' do
              expect { subject.invite(visitor) }.to change{ agent.identifiers }.to([identifier])
            end
            it 'will not increment the associated #verified_authentication_vectors' do
              expect { subject.invite(visitor) }.to_not change { agent.verified_authentication_vectors }
            end
          end
        end
      end
    end
  end
end
