require 'rails_helper'
require "generator_spec"
require 'cogitate/generators/install_generator'

RSpec.describe Cogitate::InstallGenerator, type: :generator do
  destination(Rails.root.join('tmp'))
  arguments(%w(something))

  before(:all) do
    prepare_destination
    run_generator
  end

  it "creates a test initializer" do
    assert_file "config/initializers/cogitate_initializer.rb", /Cogitate.configure do |config|/
  end
end
