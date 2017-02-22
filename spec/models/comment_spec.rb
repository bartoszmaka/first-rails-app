require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { create(:comment) }
  describe 'Comment fields and associations' do
    subject { comment }
    it { should belong_to(:user) }
    it { should belong_to(:article) }
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_least(1).is_at_most(15_000) }
  end

  describe 'author' do
    subject { comment.author }
    it 'equals #user.name' do
      expect(comment.author).to eq(comment.user.name)
    end
  end
end
