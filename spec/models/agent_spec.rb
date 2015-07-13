require 'rails_helper'

RSpec.describe Agent, type: :model do
  it 'will have a GUID'
  it { should have_many :communication_vectors }
  it { should have_many :authentication_vectors }
  it { should have_many :identifiers }

  context 'verified identity' do
    it 'will include all associated communication vectors'
    it 'will include all verified authentication vectors'
    it 'will not include unverified authentication vectors'
    it 'will include all identifiers'
  end

  context 'unverified identity' do
    context 'when the given identity is an ORCID' do
      let(:the_given_identity) { "ORCID\t0000-0001-0002-0003" }
      context 'communication vectors' do
        its(:preferred_name) { should_not be_present }
        its(:preferred_email) { should_not be_present }
      end
      context 'identification vectors' do
        it 'will have one identification_vector that is the given orcid' do
          expect(subject.identification_vectors.map(&:identity)).to eq([the_given_identity])
        end
      end
    end
    context 'when the given identity is an email' do
      let(:the_given_identity) { "EMAIL\thello@world.com" }
      context 'communication vectors' do
        its(:preferred_name) { should_not be_present }
        its(:preferred_email) { should eq(the_given_identity) }
      end
      context 'identification vectors' do
        it 'will have one identification_vector that is the given email' do
          expect(subject.identification_vectors.map { |iv| [iv.vector_type, iv.identity] }).to eq(['email', the_given_identity])
        end
      end
    end
  end
end
