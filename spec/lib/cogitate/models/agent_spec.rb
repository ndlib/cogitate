require 'spec_fast_helper'
require 'cogitate/models/agent'
require "cogitate/models/identifier"
require 'shoulda/matchers'

RSpec.describe Cogitate::Models::Agent do
  let(:identifier) { Cogitate::Models::Identifier.new(strategy: 'orcid', identifying_value: '123') }
  subject { described_class.new(identifier: identifier) }

  include Cogitate::RSpecMatchers

  context '.build_with_identifying_information' do
    subject { described_class.build_with_identifying_information(strategy: 'orcid', identifying_value: '123') }
    it { should contractually_honor(Cogitate::Interfaces::AgentInterface) }
  end

  it 'will yield an agent if a block is given on initialization' do
    expect { |b| described_class.new(identifier: identifier, &b) }.to yield_successive_args(kind_of(described_class))
  end

  its(:primary_identifier) { should eq(identifier) }
  it { should contractually_honor(Cogitate::Interfaces::AgentInterface) }
  it { should delegate_method(:strategy).to(:primary_identifier) }
  it { should delegate_method(:identifying_value).to(:primary_identifier) }
  it { should delegate_method(:id).to(:primary_identifier) }
  it { should delegate_method(:as_json).to(:serializer) }
  it { should delegate_method(:encoded_id).to(:primary_identifier) }

  context '#add_identifier' do
    it 'will increment the identifiers' do
      expect { subject.add_identifier(identifier) }.to change { subject.with_identifiers.to_a.size }.by(1)
    end
  end

  context '#with_identifiers' do
    it 'will be an Enumerator if no block is given' do
      subject.add_identifier(identifier)
      expect(subject.with_identifiers).to be_a(Enumerator)
      expect { |b| subject.with_identifiers.each(&b) }.to yield_successive_args(identifier)
    end

    it 'will yield the identifiers that were added' do
      subject.add_identifier(identifier)
      expect { |b| subject.with_identifiers(&b) }.to yield_successive_args(identifier)
    end
  end

  let(:email) { double }
  context '#add_email' do
    it 'will increment the emails' do
      expect { subject.add_email(email) }.to change { subject.with_emails.to_a.size }.by(1)
    end
  end

  context '#with_emails' do
    it 'will be an Enumerator if no block is given' do
      subject.add_email(email)
      expect(subject.with_emails).to be_a(Enumerator)
      expect { |b| subject.with_emails.each(&b) }.to yield_successive_args(email)
    end

    it 'will yield the emails that were added' do
      subject.add_email(email)
      expect { |b| subject.with_emails(&b) }.to yield_successive_args(email)
    end
  end

  context '#add_verified_identifier' do
    it 'will increment the identifiers' do
      expect { subject.add_verified_identifier(identifier) }.to change { subject.with_verified_identifiers.to_a.size }.by(1)
    end
  end

  context '#with_verified_identifiers' do
    it 'will be an Enumerator if no block is given' do
      subject.add_verified_identifier(identifier)
      expect(subject.with_verified_identifiers).to be_a(Enumerator)
      expect { |b| subject.with_verified_identifiers.each(&b) }.to yield_successive_args(identifier)
    end

    it 'will yield the identifiers that were added' do
      subject.add_verified_identifier(identifier)
      expect { |b| subject.with_verified_identifiers(&b) }.to yield_successive_args(identifier)
    end
  end

  context '#ids' do
    let(:verified_identifier) { Cogitate::Models::Identifier.new(strategy: 'verified', identifying_value: '1') }
    let(:unverified_identifier) { Cogitate::Models::Identifier.new(strategy: 'unverified', identifying_value: '2') }
    it 'will included the #id of each verified identifier' do
      subject.add_verified_identifier(verified_identifier)
      subject.add_identifier(unverified_identifier)
      expect(subject.ids.sort).to eq([subject.id, verified_identifier.id])
    end
  end
end
