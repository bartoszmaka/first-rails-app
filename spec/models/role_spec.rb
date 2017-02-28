require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:role) { Role.create(name: 'tester') }

  describe 'role associations and validations' do
    subject { role }
    it { should have_and_belong_to_many(:users) }
    it { should validate_length_of(:name).is_at_least(1) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end
end
