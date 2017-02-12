require 'rails_helper'

RSpec.describe Vote, type: :model do
  before(:each) do
    @positive_vote = create(:positive_article_vote)
    @votable = @positive_vote.votable
    @negative_vote = create(:negative_article_vote, votable: @votable)
    @old_score = @votable.score
  end

  it 'should have votable' do
    expect(@votable.class.nil?).to be false
  end

  it 'should decrease votable score by 2 after changing from positive to negative' do
    @positive_vote.downvote
    puts @votable.votes
    expect(@votable.score).to eq(@old_score - 2)
  end

  it 'should increase votable score by 2 after changing from negative to positive' do
    @negative_vote.upvote
    expect(@votable.score).to eq(@old_score + 2)
  end

  it 'should decrease votable score by 1 after deleting positive vote' do
    @positive_vote.destroy
    expect(@votable.score).to eq(@old_score - 1)
  end

  it 'should increase votable score by 1 after deleting negative vote' do
    @negative_vote.destroy
    expect(@votable.score).to eq(@old_score + 1)
  end

  it 'should increase votable score by 1 after creating positive vote' do
    # other_user = create(:user)
    # other_vote = @votable.votes.create(user: other_user, positive: true)
    # other_vote.upvote
    # expect(@votable.score).to eq(@old_score + 1)
    old_score = @votable.score
    v = Vote.create(votable: @votable, user: create(:user))
    v.upvote
    expect(@votable.score).to eq(old_score + 1)
  end

  it 'should decrease votable score by 1 after creating negative vote' do
    other_user = create(:user)
    other_vote = @votable.create(user: other_user, positive: false)
    other_vote.downvote
    expect(@votable.score).to eq(@old_score - 1)
  end
end
