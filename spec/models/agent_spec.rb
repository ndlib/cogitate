require 'rails_helper'
require 'cogitate/interfaces'

RSpec.describe Agent, type: :model do
  subject { Agent.new }
  include Cogitate::RSpecMatchers
  it { should contractually_honor(Cogitate::Interfaces::AgentInterface) }

  xit 'will have a GUID'
  xit { should have_many :communication_vectors }
  xit { should have_many :authentication_vectors }
  xit { should have_many :identifiers }

  context 'verified identity' do
    xit 'will include all associated communication vectors'
    xit 'will include all verified authentication vectors'
    xit 'will not include unverified authentication vectors'
    xit 'will include all identifiers'
  end

  context 'unverified identity' do
    context 'when the given identity is an ORCID' do
      let(:the_given_identity) { "ORCID\t0000-0001-0002-0003" }
      context 'communication vectors' do
        # xits(:preferred_name) { should_not be_present }
        # xits(:preferred_email) { should_not be_present }
      end
      context 'identification vectors' do
        xit 'will have one identification_vector that is the given orcid' do
          expect(subject.identification_vectors.map(&:identity)).to eq([the_given_identity])
        end
      end
    end
    context 'when the given identity is an email' do
      let(:the_given_identity) { "EMAIL\thello@world.com" }
      context 'communication vectors' do
        # xits(:preferred_name) { should_not be_present }
        # xits(:preferred_email) { should eq(the_given_identity) }
      end
      context 'identification vectors' do
        xit 'will have one identification_vector that is the given email' do
          expect(subject.identification_vectors.map { |iv| [iv.vector_type, iv.identity] }).to eq(['email', the_given_identity])
        end
      end
    end
  end
end
