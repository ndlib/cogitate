require 'rails_helper'
require 'cogitate/railtie'

RSpec.describe Cogitate::Railtie do
  it 'will load generators' do
    expect(Cogitate::Railtie).to receive(:require).with('cogitate/generators/install_generator')
    Cogitate::Railtie.generators.each(&:call)
  end
end
