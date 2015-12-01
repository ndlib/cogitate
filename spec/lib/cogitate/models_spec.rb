require 'spec_fast_helper'
require 'cogitate/models'

RSpec.describe Cogitate do
  its(:constants) { should include(:Models) }
end
