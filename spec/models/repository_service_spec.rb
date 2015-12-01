require 'spec_fast_helper'
require 'repository_service'

RSpec.describe RepositoryService do
  subject { described_class }
  its(:table_name_prefix) { should eq('repository_service_') }
end
