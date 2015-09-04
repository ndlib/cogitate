require 'spec_fast_helper'
require 'cogitate/services/membership_visitation_strategy/do_not_visit_memberships_service'

RSpec.describe Cogitate::Services::MembershipVisitationStrategy::DoNotVisitMembershipsService do
  subject { described_class }
  its(:call) { should be_nil }
end
