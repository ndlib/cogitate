require 'spec_fast_helper'
require 'shoulda/matchers'
require 'authentication_vector/netid_vector'

module AuthenticationVector
  RSpec.describe NetidVector do
    let(:identifier) { double }
    subject { described_class.new(identifier: identifier, first_name: 'A First Name') }
    include Cogitate::RSpecMatchers
    it { should contractually_honor(Cogitate::Interfaces::AuthenticationVectorNetidInterface) }
    it { should delegate_method(:strategy).to(:identifier) }
    it { should delegate_method(:<=>).to(:identifier) }
  end
end
