require 'spec_helper'
require 'cogitate/services/tokenizer'

RSpec.describe Cogitate::Services::Tokenizer do
  context '.from_token' do
    subject { described_class }
    it { should respond_to(:from_token) }
  end

  context '.to_token' do
    subject { described_class }
    it { should respond_to(:to_token) }
  end
end
