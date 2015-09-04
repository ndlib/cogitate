require 'spec_fast_helper'
require 'cogitate/services/membership_visitation_strategy'

RSpec.describe Cogitate::Services::MembershipVisitationStrategy do
  subject { described_class }
  let(:identifier) { double(verified?: true, strategy: 'hello') }
  context '.find' do
    it 'will retrieve a callable strategy if the lookup table works' do
      subject.find(identifier: identifier, visitation_type: :first)
    end

    it 'will throw a KeyError' do
      subject.find(identifier: identifier, visitation_type: :first)
    end
  end
end
