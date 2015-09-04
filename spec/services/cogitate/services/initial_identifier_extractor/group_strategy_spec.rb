require 'spec_fast_helper'
require 'cogitate/services/initial_identifier_extractor/group_strategy'
require 'cogitate/models/identifier'

RSpec.describe Cogitate::Services::InitialIdentifierExtractor::GroupStrategy do
  let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'group', identifying_value: 'a group') }
  let(:membership_visitation_service) { double(call: true) }
  let(:repository) { double(with_verified_existing_group_for: true) }
  let(:is_verified) { true }
  subject do
    described_class.new(identifier: identifier, repository: repository, membership_visitation_service: membership_visitation_service)
  end

  its(:default_membership_visitation_service) { should respond_to(:call) }
  its(:default_repository) { should respond_to(:with_verified_existing_group_for) }

  include Cogitate::RSpecMatchers
  it 'will expose .call as a convenience method' do
    expect(described_class.call(identifier: identifier)).to contractually_honor(Cogitate::Interfaces::HostInterface)
  end

  let(:guest) { double(visit: true) }
  let(:visitor) { double(add_identifier: true, add_verified_identifier: true) }
  before { allow(guest).to receive(:visit).and_yield(visitor) }

  context 'group is a verified group' do
    before { expect(repository).to receive(:with_verified_existing_group_for).with(identifier: identifier).and_yield(identifier) }
    it 'will tell the visitor to add the identifier as an unverified identifier' do
      subject.invite(guest)
      expect(visitor).to have_received(:add_identifier).with(identifier)
    end
    it 'will tell the visitor to add the identifier as a verified identifier' do
      subject.invite(guest)
      expect(visitor).to have_received(:add_verified_identifier).with(identifier)
    end
    it 'will call the membership_visitation_service' do
      subject.invite(guest)
      expect(membership_visitation_service).to have_received(:call).with(identifier: identifier, visitor: visitor)
    end
  end

  context 'group is not a verified group' do
    before { expect(repository).to receive(:with_verified_existing_group_for).with(identifier: identifier) }
    it 'will tell the visitor to add the identifier as an unverified identifier' do
      subject.invite(guest)
      expect(visitor).to have_received(:add_identifier).with(identifier)
    end
    it 'will NOT tell the visitor to add the identifier as an verified identifier' do
      subject.invite(guest)
      expect(visitor).to_not have_received(:add_verified_identifier)
    end
    it 'will NOT call the membership_visitation_service' do
      subject.invite(guest)
      expect(membership_visitation_service).to_not have_received(:call)
    end
  end
end
