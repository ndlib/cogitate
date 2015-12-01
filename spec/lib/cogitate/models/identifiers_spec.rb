require 'spec_fast_helper'
require 'cogitate/models/identifiers'

RSpec.describe Cogitate::Models do
  its(:constants) { should include(:Identifiers) }
end
