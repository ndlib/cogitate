require 'spec_fast_helper'
require 'cogitate/services/identifying_host_extractor/netid_strategy'
require 'cogitate/interfaces'

module Cogitate
  module Services
    module IdentifyingHostExtractor
      RSpec.describe NetidStrategy do
        let(:identifier) { double(strategy: 'netid', identifying_value: 'hello') }
        let(:repository) { double(find: true) }
        let(:host_builder) { double(call: true) }
        let(:host) { double(invite: true) }
        subject { described_class.new(identifier: identifier, repository: repository, host_builder: host_builder) }

        include Cogitate::RSpecMatchers
        its(:default_repository) { should contractually_honor(Cogitate::Interfaces::FindNetidRepositoryInterface) }

        context '#call' do
          before { expect(repository).to receive(:find).and_return(repository_response) }
          context 'when Netid exists according to the remote query service' do
            let(:repository_response) { double(verified?: true) }
            before do
              expect(host_builder).to receive(:call).with(invitation_strategy: :verified, identifier: repository_response).and_return(host)
            end
            its(:call) { should contractually_honor(Cogitate::Interfaces::HostInterface) }
          end
          context 'when Netid does not exist according to our remote query service' do
            let(:repository_response) { double(verified?: false) }
            before do
              expect(host_builder).to receive(:call).with(
                invitation_strategy: :unverified, identifier: repository_response
              ).and_return(host)
            end
            its(:call) { should contractually_honor(Cogitate::Interfaces::HostInterface) }
          end
        end
      end

      class NetidStrategy
        RSpec.describe Host do
          let(:identifier) { double(strategy: 'netid', identifying_value: '123') }
          let(:invitation_strategy) { :none }
          let(:guest) { double(visit: true) }
          let(:visitor) { double(add_identity: true, add_verified_authentication_vector: true) }
          subject { described_class.new(invitation_strategy: invitation_strategy, identifier: identifier) }
          before { allow(guest).to receive(:visit).and_yield(visitor) }
          context ':verified invitation_strategy' do
            let(:invitation_strategy) { :verified }
            it 'will add the identity to the visitor' do
              expect(visitor).to receive(:add_identity).with(identifier)
              subject.invite(guest)
            end
            it 'will NOT add a verified authentication vector to the visitor' do
              expect(visitor).to receive(:add_verified_authentication_vector).with(identifier)
              subject.invite(guest)
            end
          end
          context ':unverified invitation_strategy' do
            let(:invitation_strategy) { :unverified }
            it 'will add the identity to the visitor' do
              expect(visitor).to receive(:add_identity).with(identifier)
              subject.invite(guest)
            end
            it 'will NOT add a verified authentication vector to the visitor' do
              expect(visitor).to_not receive(:add_verified_authentication_vector)
              subject.invite(guest)
            end
          end
          context ':missing invitation strategy' do
            it 'will fail on #invite' do
              expect { subject.invite(guest) }.to raise_error(NoMethodError)
            end
          end
        end
      end
    end
  end
end
