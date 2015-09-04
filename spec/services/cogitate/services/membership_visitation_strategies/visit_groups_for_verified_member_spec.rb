require 'spec_fast_helper'
require 'cogitate/services/membership_visitation_strategies/visit_groups_for_verified_member'
require 'cogitate/query_repository'
require "cogitate/models/identifier"
module Cogitate
  module Services
    module MembershipVisitationStrategies
      RSpec.describe VisitGroupsForVerifiedMember do
        let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: 'hello') }
        let(:guest) { double(visit: true) }
        let(:visitor) { double(add_identifier: true, add_verified_identifier: true) }
        let(:group_identifier) { Cogitate::Models::Identifier.new(strategy: 'group', identifying_value: 'one') }
        let(:implicit_group_identifier) { Cogitate::Models::Identifier.new_for_implicit_verified_group_by_strategy(strategy: 'netid') }
        let(:identifier_extractor) { double('Identifier Extractor', call: true) }
        let(:repository) { double(with_verified_group_identifier_related_to: [group_identifier]) }

        subject do
          described_class.new(
            group_member_identifier: identifier, guest: guest, repository: repository, identifier_extractor: identifier_extractor
          )
        end

        before do
          allow(guest).to receive(:visit).with(group_identifier).and_yield(visitor)
          allow(guest).to receive(:visit).with(implicit_group_identifier).and_yield(visitor)
        end

        its(:default_repository) { should respond_to(:with_verified_group_identifier_related_to) }
        its(:default_identifier_extractor) { should respond_to(:call) }

        it 'will initialize without optional keywords' do
          expect_any_instance_of(Cogitate::QueryRepository).to receive(:with_verified_group_identifier_related_to)
          expect(described_class.new(group_member_identifier: identifier, guest: guest)).to be_a(described_class)
        end

        context '.call' do
          it 'will call the underlying instantiated object' do
            expect_any_instance_of(described_class).to receive(:call)
            described_class.call(identifier: identifier, visitor: guest, repository: repository)
          end
        end

        context '#call' do
          it 'will receive the visitor adding the group identifiers to the identities of the visitor' do
            expect(visitor).to receive(:add_identifier).with(group_identifier)
            expect(visitor).to receive(:add_verified_identifier).with(group_identifier)
            expect(visitor).to receive(:add_identifier).with(implicit_group_identifier)
            expect(visitor).to receive(:add_verified_identifier).with(implicit_group_identifier)
            expect(identifier_extractor).to receive(:call).with(identifier: group_identifier, visitor: guest, visitation_type: :next)
            expect(identifier_extractor).to receive(:call).with(
              identifier: implicit_group_identifier, visitor: guest, visitation_type: :next
            )
            subject.call
          end
        end
      end
    end
  end
end
