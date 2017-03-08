require 'rails_helper'

describe Archivement, type: :model do
  let(:archivement) { create(:archivement) }
  describe 'Archivement' do
    subject { archivement }
    it { should have_many(:user_archivements) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end
end
