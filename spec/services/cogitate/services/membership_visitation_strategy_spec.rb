require 'spec_fast_helper'
require 'cogitate/services/membership_visitation_strategy'

RSpec.describe Cogitate::Services::MembershipVisitationStrategy do
  subject { described_class }
  let(:identifier) { double(verified?: true, strategy: 'hello') }
  context '.find' do
    it 'will retrieve a callable strategy if the lookup table works' do
      expect(subject.find(identifier: identifier, visitation_type: :first)).to respond_to(:call)
    end

    it 'will retrieve a callable strategy even if the identifier is not verifiable' do
      identifier = double(strategy: 'hello')
      expect(subject.find(identifier: identifier, visitation_type: :first)).to respond_to(:call)
    end

    it 'will throw a Exceptions::InvalidMembershipVisitationKeys with bad data' do
      expect { subject.find(identifier: identifier, visitation_type: :chicken) }.to raise_error(Cogitate::InvalidMembershipVisitationKeys)
    end
  end
end
