require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'vote' do
    subject { create(:article_vote) }
    it { should belong_to(:votable) }
    it { should belong_to(:user) }
  end

  describe '#upvote' do
    let!(:article) { create(:article) }
    let!(:old_score) { article.score }
    context 'when votable had no vote from this user' do
      it 'increases score by 1' do
        v = build(:vote, votable: article)
        v.upvote
        v.save
        expect(article.score).to eq(old_score + 1)
      end
    end
    context 'when votable had positive vote from this user' do
      it 'does not change score' do
        v = create(:vote, votable: article, positive: true)
        v.upvote
        expect(article.score).to eq(old_score)
      end
    end
    context 'when votable had negative vote from this user' do
      it 'increases score by 2' do
        v = create(:vote, votable: article, positive: false)
        v.upvote
        expect(article.score).to eq(old_score + 2)
      end
    end
  end

  describe '#downvote' do
    let!(:article) { create(:article) }
    let!(:old_score) { article.score }
    context 'when votable had no vote from this user' do
      it 'decreases score by 1' do
        v = build(:vote, votable: article)
        v.downvote
        v.save
        expect(article.score).to eq(old_score - 1)
      end
    end
    context 'when votable had negative vote from this user' do
      it 'does not change score' do
        v = create(:vote, votable: article, positive: false)
        v.downvote
        expect(article.score).to eq(old_score)
      end
    end
    context 'when votable had positive vote from this user' do
      it 'decreases score by 2' do
        v = create(:vote, votable: article, positive: true)
        v.downvote
        expect(article.score).to eq(old_score - 2)
      end
    end
  end
end
