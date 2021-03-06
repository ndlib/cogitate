require 'rails_helper'
require 'cogitate/query_repository'
require "cogitate/models/identifier"
require 'cogitate/models/identifiers/verified/group'
require 'group'

module Cogitate
  RSpec.describe QueryRepository do
    let(:identifier_relationship_repository) { double(each_identifier_related_to: true) }
    its(:default_identifier_relationship_repository) { should respond_to(:each_identifier_related_to) }
    let(:group_identifier) { Models::Identifier.new(strategy: Models::Identifier::GROUP_STRATEGY_NAME, identifying_value: 'a-group') }
    let(:verified_group) { double('A verified group') }

    subject { described_class.new(identifier_relationship_repository: identifier_relationship_repository) }

    it { should delegate_method(:each_identifier_related_to).to(:identifier_relationship_repository) }

    context '#with_verified_group_identifier_related_to' do
      let(:given_identifier) { Cogitate::Models::Identifier.new(strategy: 'netid', identifying_value: 'hello') }
      before do
        allow(identifier_relationship_repository).to receive(:each_identifier_related_to).and_yield(group_identifier)
        allow(subject).to receive(:with_verified_existing_group_for).with(identifier: group_identifier).and_yield(verified_group)
      end

      it 'will return an Enumerator if no block is given' do
        enumerator = subject.with_verified_group_identifier_related_to(identifier: given_identifier)
        expect(enumerator).to be_a(Enumerator)
        expect { |b| enumerator.each(&b) }.to yield_successive_args(verified_group)
      end

      it 'will yield each verified group' do
        expect { |b| subject.with_verified_group_identifier_related_to(identifier: given_identifier, &b) }.to(
          yield_successive_args(verified_group)
        )
      end
    end

    context '#with_verified_existing_group_for' do
      context 'when the group exists' do
        before { ::Group.new(identifying_value: group_identifier.identifying_value, name: 'Hello').save! }

        it 'will yield an Identifiers::Verified::Group' do
          expect { |b| subject.with_verified_existing_group_for(identifier: group_identifier, &b) }.to(
            yield_successive_args(kind_of(Cogitate::Models::Identifiers::Verified::Group))
          )
        end

        it 'will not yield if the identifier ' do
          non_group_identifier = Cogitate::Models::Identifier.new(
            strategy: 'not-a-group', identifying_value: group_identifier.identifying_value
          )
          expect { |b| subject.with_verified_existing_group_for(identifier: non_group_identifier, &b) }.to_not yield_control
        end
      end

      context 'when the group does not exist' do
        it 'will not yield control' do
          expect { |b| subject.with_verified_existing_group_for(identifier: group_identifier, &b) }.to_not yield_control
        end
      end
    end
  end
end
