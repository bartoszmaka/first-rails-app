require 'rails_helper'

RSpec.describe Vote, type: :model do
  before(:each) do
    @vote = build(:positive_article_vote)
    @votable = @vote.votable
    @positive_vote = create(:positive_article_vote, votable: @votable)
    @negative_vote = create(:negative_article_vote, votable: @votable)
    @old_score = @votable.score
  end

  it 'has valid factory' do
    expect(@vote.valid?).to be true
  end

  it 'belongs to votable' do
    @vote.votable = nil
    expect(@vote.valid?).to be false
  end

  it 'belongs to user' do
    @vote.user = nil
    expect(@vote.valid?).to be false
  end

  it 'increases votable score by 1 after upvoting new vote' do
    @vote.upvote
    expect(@votable.score).to eq(@old_score + 1)
  end

  it 'decreases votable score by 1 after downvoting new vote' do
    @vote.downvote
    expect(@votable.score).to eq(@old_score - 1)
  end

  it 'remains the same after upvoting positive vote' do
    @positive_vote.upvote
    expect(@votable.score).to eq(@old_score)
  end

  it 'remains the same after downvoting negative vote' do
    @negative_vote.downvote
    expect(@votable.score).to eq(@old_score)
  end

  it 'increases votable score by 2 after upvoting negative vote' do
    @negative_vote.upvote
    expect(@votable.score).to eq(@old_score + 2)
  end

  it 'decreases votable score by 2 after downvoting positive vote' do
    @positive_vote.downvote
    expect(@votable.score).to eq(@old_score - 2)
  end

  it 'decreases votable score by 1 after destroying positive vote' do
    @positive_vote.destroy
    expect(@votable.score).to eq(@old_score - 1)
  end

  it 'increases votable score by 1 after destroying negative vote' do
    @negative_vote.destroy
    expect(@votable.score).to eq(@old_score + 1)
  end
end
