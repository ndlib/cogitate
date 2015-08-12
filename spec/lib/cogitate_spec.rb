require 'spec_fast_helper'
require 'cogitate'

RSpec.describe Cogitate do
  subject { described_class }
  around do |example|
    old_config = Cogitate.configuration
    example.run
    Cogitate.configuration = old_config
  end
  its(:configuration) { should be_a Cogitate::Configuration }
  it { expect { |b| described_class.configure(&b) }.to yield_successive_args(kind_of(Cogitate::Configuration)) }
end
