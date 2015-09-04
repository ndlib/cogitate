require 'spec_fast_helper'
require 'cogitate/services/identifier_extractors/netid_strategy'
require 'cogitate/interfaces'
require "cogitate/models/identifier"

module Cogitate
  module Services
    module IdentifierExtractors
      RSpec.describe NetidStrategy do
        let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: 'hello') }
        let(:repository) { double('Repository', find: true) }
        let(:host_builder) { ->(**_keywords) { host } }
        let(:membership_visitation_service) { double('Membership Visitation Service', call: true) }
        let(:host) { double(invite: true) }
        subject do
          described_class.new(
            membership_visitation_service: membership_visitation_service, identifier: identifier,
            repository: repository, host_builder: host_builder
          )
        end

        include Cogitate::RSpecMatchers
        its(:default_repository) { should contractually_honor(Cogitate::Interfaces::FindNetidRepositoryInterface) }
        its(:default_host_builder) { should respond_to(:call) }

        context '.call' do
          it 'will be a convenience method' do
            expect_any_instance_of(described_class).to receive(:call).and_return(host)
            described_class.call(identifier: identifier, membership_visitation_service: membership_visitation_service)
          end
        end

        context '#call' do
          before { expect(repository).to receive(:find).and_return(repository_response) }
          context 'when Netid exists according to the remote query service' do
            let(:repository_response) { double(verified?: true) }
            before do
              expect(host_builder).to receive(:call).with(
                invitation_strategy: :verified, identifier: repository_response,
                membership_visitation_service: membership_visitation_service
              ).and_return(host)
            end
            its(:call) { should contractually_honor(Cogitate::Interfaces::HostInterface) }
          end
          context 'when Netid does not exist according to our remote query service' do
            let(:repository_response) { double(verified?: false) }
            before do
              expect(host_builder).to receive(:call).with(
                invitation_strategy: :unverified, identifier: repository_response,
                membership_visitation_service: membership_visitation_service
              ).and_return(host)
            end
            its(:call) { should contractually_honor(Cogitate::Interfaces::HostInterface) }
          end
        end
      end

      class NetidStrategy
        RSpec.describe Host do
          let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: '123') }
          let(:invitation_strategy) { :none }
          let(:guest) { double(visit: true) }
          let(:visitor) { double(add_identifier: true, add_verified_identifier: true) }
          let(:membership_visitation_service) { double(call: true) }
          subject do
            described_class.new(
              invitation_strategy: invitation_strategy, identifier: identifier, membership_visitation_service: membership_visitation_service
            )
          end
          before { allow(guest).to receive(:visit).with(identifier).and_yield(visitor) }
          context ':verified invitation_strategy' do
            let(:invitation_strategy) { :verified }
            it 'will add the identity to the visitor' do
              expect(visitor).to receive(:add_identifier).with(identifier)
              subject.invite(guest)
            end
            it 'will NOT add a verified authentication vector to the visitor' do
              expect(visitor).to receive(:add_verified_identifier).with(identifier)
              subject.invite(guest)
            end
            it 'will call the associated membership_visitation_service' do
              expect(membership_visitation_service).to receive(:call).with(identifier: identifier, visitor: visitor)
              subject.invite(guest)
            end
          end
          context ':unverified invitation_strategy' do
            let(:invitation_strategy) { :unverified }
            it 'will add the identity to the visitor' do
              expect(visitor).to receive(:add_identifier).with(identifier)
              subject.invite(guest)
            end
            it 'will NOT add a verified authentication vector to the visitor' do
              expect(visitor).to_not receive(:add_verified_identifier)
              subject.invite(guest)
            end
            it 'will NOT call the associated membership_visitation_service' do
              expect(membership_visitation_service).to_not receive(:call)
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
