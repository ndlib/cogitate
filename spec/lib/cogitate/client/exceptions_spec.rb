require 'spec_fast_helper'
require 'cogitate/client/exceptions'

RSpec.describe Cogitate::Client::ResponseParserNotFound do
  subject { described_class.new('A Parser Name', Cogitate::Client) }

  it 'will have a meaningful message' do
    expect(subject.to_s).to eq('Unable to find "A Parser Name" parser in Cogitate::Client')
  end
end
