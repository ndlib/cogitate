require 'spec_fast_helper'
require 'cogitate/services/agent_extractor/netid_strategy'

module Cogitate
  module Services
    module AgentExtractor
      RSpec.describe NetidStrategy do
        let(:identity) { double(strategy: 'netid', identifying_value: 'hello') }
        let(:agent) { double(identities: [], verified_authentication_vectors: []) }
        subject { described_class.new(identity: identity) }

        include Cogitate::RSpecMatchers
        its(:default_agent) { should contractually_honor(Cogitate::Interfaces::AgentInterface) }

        context 'with a Netid that does not exist in the remote system' do
          before { allow(subject).to receive(:fetch_remote_data_for_netid).and_return(nil)  }
          it 'will not have any verified authentication vectors' do
            subject.call(agent: agent)
            expect(agent.verified_authentication_vectors).to eq([])
          end
          it 'will have one identity (the given netid)' do
            subject.call(agent: agent)
            expect(agent.identities).to eq([identity])
          end
        end
        context 'with a Netid that exists in the remote system' do
          before { allow(subject).to receive(:fetch_remote_data_for_netid).and_return(true)  }
          context 'verified authentication vectors' do
            it 'will include the given Netid' do
              subject.call(agent: agent)
              expect(agent.verified_authentication_vectors).to include(identity)
            end
            it 'will include any associated verified authentication vectors'
          end
          context 'identities' do
            it 'will include the given Netid'
          end
        end
      end
    end
  end
end
