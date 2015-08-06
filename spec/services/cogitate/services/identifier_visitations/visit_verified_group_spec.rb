require 'spec_fast_helper'
require 'cogitate/services/identifier_visitations/visit_verified_group'
require 'cogitate/query_repository'
require 'identifier'
module Cogitate
  module Services
    module IdentifierVisitations
      RSpec.describe VisitVerifiedGroup do
        let(:identifier) { Identifier.new(strategy: 'netid', identifying_value: 'hello') }
        let(:guest) { double(visit: true) }
        let(:visitor) { double(add_identifier: true, add_verified_identifier: true) }
        let(:group_identifier) { Identifier.new(strategy: 'group', identifying_value: 'one') }
        let(:repository) { double(with_verified_group_identifier_related_to: [group_identifier]) }

        subject { described_class.new(group_member_identifier: identifier, guest: guest, repository: repository) }

        before { allow(guest).to receive(:visit).with(group_identifier).and_yield(visitor) }

        its(:default_repository) { should respond_to(:with_verified_group_identifier_related_to) }

        it 'will initialize without optional keywords' do
          expect_any_instance_of(Cogitate::QueryRepository).to receive(:with_verified_group_identifier_related_to)
          expect(described_class.new(group_member_identifier: identifier, guest: guest)).to be_a(described_class)
        end

        context '.call' do
          it 'will call the underlying instantiated object' do
            expect(visitor).to receive(:add_identifier).with(group_identifier)
            expect(visitor).to receive(:add_verified_identifier).with(group_identifier)
            described_class.call(identifier: identifier, visitor: guest, repository: repository)
          end
        end

        context '#call' do
          it 'will receive the visitor adding the group identifiers to the identities of the visitor' do
            expect(visitor).to receive(:add_identifier).with(group_identifier)
            expect(visitor).to receive(:add_verified_identifier).with(group_identifier)
            subject.call
          end
        end
      end
    end
  end
end
