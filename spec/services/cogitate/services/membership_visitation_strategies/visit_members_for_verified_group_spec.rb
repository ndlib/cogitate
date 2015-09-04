require 'spec_fast_helper'
require 'cogitate/models/identifier'
require 'cogitate/services/membership_visitation_strategies/visit_members_for_verified_group'

RSpec.describe Cogitate::Services::MembershipVisitationStrategies::VisitMembersForVerifiedGroup do
  let(:group_identifier) { Cogitate::Models::Identifier.new(strategy: 'group', identifying_value: 'hello') }
  let(:guest) { double(visit: true) }
  let(:visitor) { double(add_identifier: true, add_verified_identifier: true) }
  let(:repository) { double('Repository', each_identifier_related_to: true) }
  let(:identifier_extractor) { double('Identifier Extractor', call: true) }
  before { allow(guest).to receive(:visit).and_yield(visitor) }
  subject do
    described_class.new(
      group_identifier: group_identifier, guest: guest, repository: repository, identifier_extractor: identifier_extractor
    )
  end

  its(:default_repository) { should respond_to(:each_identifier_related_to) }
  its(:default_identifier_extractor) { should respond_to(:call) }

  it 'exposes .call as a convenience method' do
    expect_any_instance_of(described_class).to receive(:call)
    described_class.call(identifier: group_identifier, visitor: guest)
  end

  it 'will look at all group members and gather their information' do
    member_identifier = double
    expect(repository).to receive(:each_identifier_related_to).and_yield(member_identifier)
    subject.call
    expect(identifier_extractor).to have_received(:call).with(identifier: member_identifier, visitor: guest, visitation_type: :next)
  end
end
