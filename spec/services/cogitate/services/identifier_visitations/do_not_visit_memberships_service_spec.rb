require 'spec_fast_helper'
require 'cogitate/services/identifier_visitations/do_not_visit_memberships_service'

RSpec.describe Cogitate::Services::IdentifierVisitations::DoNotVisitMembershipsService do
  subject { described_class }
  its(:call) { should be_nil }
end
