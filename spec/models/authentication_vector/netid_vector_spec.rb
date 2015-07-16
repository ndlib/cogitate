require 'spec_fast_helper'
require 'authentication_vector/netid_vector'

module AuthenticationVector
  RSpec.describe NetidVector do
    subject { described_class.new(first_name: 'A First Name') }
    include Cogitate::RSpecMatchers
    it { should contractually_honor(Cogitate::Interfaces::AuthenticationVectorNetidInterface) }
  end
end
