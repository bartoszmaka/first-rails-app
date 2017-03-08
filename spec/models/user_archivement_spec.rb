require 'rails_helper'

describe UserArchivement, type: :model do
  let(:user_archivement) { create(:user_archivement) }
  describe 'UserArchivement' do
    subject { user_archivement }
    it { should belong_to(:user) }
    it { should belong_to(:archivement) }
    it { should validate_uniqueness_of(:archivement_id).scoped_to(:user_id) }
  end
end
