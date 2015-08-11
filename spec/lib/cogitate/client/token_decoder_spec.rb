require 'spec_fast_helper'
require 'cogitate/client/token_decoder'

RSpec.describe Cogitate::Client::TokenDecoder do
  let(:token) { double("Token") }
  subject { described_class.new(token: token) }
  it 'will expose a .call as part of the public API' do
    expect_any_instance_of(described_class).to receive(:call)
    described_class.call(token: token)
  end
end
