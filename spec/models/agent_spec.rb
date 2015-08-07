require 'spec_fast_helper'
require 'agent'
require 'identifier'
require 'shoulda/matchers'
require 'base64'

RSpec.describe Agent do
  let(:identifier) { Identifier.new(strategy: 'orcid', identifying_value: '123') }
  subject { Agent.new(identifier: identifier) }

  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::AgentInterface) }

  its(:primary_identifier) { should eq(identifier) }

  it { should delegate_method(:strategy).to(:primary_identifier) }
  it { should delegate_method(:identifying_value).to(:primary_identifier) }
  it { should delegate_method(:as_json).to(:serializer) }
  it { should delegate_method(:encoded_id).to(:primary_identifier) }

  context '#add_identifier' do
    it 'will increment the identifiers' do
      expect { subject.add_identifier(identifier) }.to change { subject.send(:identities).size }.by(1)
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
      expect { subject.add_email(email) }.to change { subject.send(:emails).size }.by(1)
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
      expect { subject.add_verified_identifier(identifier) }.to change { subject.send(:verified_identities).size }.by(1)
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
end
