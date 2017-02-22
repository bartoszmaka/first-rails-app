require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'user associations and validations' do
    let(:user) { build(:user, password: nil) }
    subject { user }
    it { should have_many(:articles) }
    it { should have_many(:comments) }
    it { should have_many(:votes) }
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(255) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should_not allow_value('        ').for(:password) }
    it { should_not allow_value('        ').for(:email) }
  end

  describe 'articles count counter cache' do
    let!(:user) { create(:user) }
    let!(:article) { create(:article, user: user) }
    let!(:old_articles_count) { user.articles_count }
    it 'increases by 1 after creating article' do
      create(:article, user: user)
      expect(user.articles_count).to eq(old_articles_count + 1)
    end
    it 'decreases by 1 after destroying article' do
      article.destroy
      expect(user.articles_count).to eq(old_articles_count - 1)
    end
  end

  describe 'comments count counter cache' do
    let!(:user) { create(:user) }
    let!(:comment) { create(:comment, user: user) }
    let!(:old_comments_count) { user.comments_count }
    it 'increases by 1 after creating comment' do
      create(:comment, user: user)
      expect(user.comments_count).to eq(old_comments_count + 1)
    end
    it 'decreases by 1 after destroying comment' do
      comment.destroy
      expect(user.comments_count).to eq(old_comments_count - 1)
    end
  end
end
