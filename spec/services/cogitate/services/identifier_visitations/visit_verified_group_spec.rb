require 'spec_fast_helper'
require 'cogitate/services/identifier_visitations/visit_verified_group'
require 'identifier'
module Cogitate
  module Services
    module IdentifierVisitations
      RSpec.describe VisitVerifiedGroup do
        let(:identifier) { Identifier.new(strategy: 'netid', identifying_value: 'hello') }
        let(:guest) { double(visit: true) }
        let(:visitor) { double(add_identity: true, add_verified_authentication_vector: true) }
        let(:group_identifier) { Identifier.new(strategy: 'group', identifying_value: 'one') }
        let(:repository) { double(each_identifier_related_to: [group_identifier]) }

        subject { described_class.new(group_member_identifier: identifier, guest: guest, repository: repository) }

        before { allow(guest).to receive(:visit).with(group_identifier).and_yield(visitor) }

        its(:default_repository) { should respond_to(:each_identifier_related_to) }

        context '.call' do
          it 'will call the underlying instantiated object' do
            expect(visitor).to receive(:add_identity).with(group_identifier)
            expect(visitor).to receive(:add_verified_authentication_vector).with(group_identifier)
            described_class.call(identifier: identifier, visitor: guest, repository: repository)
          end
        end

        context '#call' do
          it 'will receive the visitor adding the group identifiers to the identities of the visitor' do
            expect(visitor).to receive(:add_identity).with(group_identifier)
            expect(visitor).to receive(:add_verified_authentication_vector).with(group_identifier)
            subject.call
          end
        end
      end
    end
  end
end
