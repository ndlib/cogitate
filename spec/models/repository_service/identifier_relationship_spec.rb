require 'rails_helper'
require 'identifier'
require 'repository_service/identifier_relationship'

module RepositoryService
  RSpec.describe IdentifierRelationship, type: :model do
    context '.each_identifier_related_to' do
      before do
        described_class.create!(left_strategy: 'a', left_identifying_value: '1', right_strategy: 'b', right_identifying_value: '2')
        described_class.create!(left_strategy: 'c', left_identifying_value: '3', right_strategy: 'a', right_identifying_value: '1')
        described_class.create!(left_strategy: 'c', left_identifying_value: '3', right_strategy: 'b', right_identifying_value: '2')
        described_class.create!(left_strategy: 'd', left_identifying_value: '4', right_strategy: 'b', right_identifying_value: '2')
      end
      let(:given_identifer) { Identifier.new(strategy: 'a', identifying_value: '1') }

      context 'without a given strategy' do
        it 'will return an Enumerator if no block is given' do
          enumerator = described_class.each_identifier_related_to(identifier: given_identifer)
          expect(enumerator).to be_a(Enumerator)
          expect { |b| enumerator.each(&b) }.to yield_successive_args(
            Identifier.new(strategy: 'b', identifying_value: '2'), Identifier.new(strategy: 'c', identifying_value: '3')
          )
        end

        it 'will yield each Identifier if a block is given' do
          expect { |b| described_class.each_identifier_related_to(identifier: given_identifer, &b) }.to yield_successive_args(
            Identifier.new(strategy: 'b', identifying_value: '2'), Identifier.new(strategy: 'c', identifying_value: '3')
          )
        end
      end

      context 'with a given strategy' do
        it 'will return an Enumerator if no block is given' do
          enumerator = described_class.each_identifier_related_to(identifier: given_identifer, strategy: 'b')
          expect(enumerator).to be_a(Enumerator)
          expect { |b| enumerator.each(&b) }.to yield_successive_args(Identifier.new(strategy: 'b', identifying_value: '2'))
        end

        it 'will yield each Identifier if a block is given' do
          expect do |b|
            described_class.each_identifier_related_to(identifier: given_identifer, strategy: 'b', &b)
          end.to yield_successive_args(Identifier.new(strategy: 'b', identifying_value: '2'))
        end
      end
    end
  end
end
