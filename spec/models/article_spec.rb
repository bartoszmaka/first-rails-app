require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user) { create(:user) }
  let(:article) { create(:article, user: user) }
  let(:vote) { create(:vote, votable: article, user: user, positive: true) }
  describe 'article associations and validations' do
    subject { create(:article) }
    it { should be_valid }
    it { should belong_to(:user) }
    it { should have_many(:comments) }
    it { should validate_length_of(:title).is_at_least(3).is_at_most(500) }
    it { should validate_length_of(:content).is_at_least(5) }
    it { should_not allow_value(nil).for(:title) }
    it { should_not allow_value(nil).for(:content) }
    it { should_not allow_value('').for(:title) }
    it { should_not allow_value('').for(:content) }
  end

  describe 'article comments caching' do
    let!(:comment) { create(:comment, article: article) }
    let!(:old_comments_count) { article.comments_count }
    it 'should increase comments_count by 1 after creating comment' do
      create(:comment, article: article)
      expect(article.comments_count).to eq(old_comments_count + 1)
    end

    it 'should decrease comments_count by 1 after deleting comment' do
      comment.destroy
      expect(article.comments_count).to eq(old_comments_count - 1)
    end
  end

  describe 'vote by user' do
    it 'expects to return vote' do
      vote = create(:vote, user: user, votable: article, positive: true)
      expect(article.vote_by_user(user)).to eq vote
    end
  end

  describe 'author' do
    it 'equals #user.name' do
      expect(article.author).to eq(article.user.name)
    end
  end
end
