require 'rails_helper'

RSpec.describe Group, type: :model do
  context 'class configuration' do
    subject { described_class }
    its(:primary_key) { should eq('id') }
  end

  context '.create' do
    it 'will require a name and id' do
      expect { described_class.create(name: nil, id: nil) }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end
end
