require 'rails_helper'

RSpec.describe Vote, type: :model do
  before(:each) do
    @positive_vote = create(:positive_article_vote)
    @votable = @positive_vote.votable
    @negative_vote = create(:negative_article_vote, votable: @votable)
    @empty_vote = create(:empty_article_vote, votable: @votable)
    @old_score = @votable.score
  end

  it 'should have votable' do
    expect(@votable.class.nil?).to be false
  end

  it 'should decrease votable score by 2 after changing from positive to negative' do
    @positive_vote.downvote
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
    @empty_vote.upvote
    expect(@votable.score).to eq(@old_score + 1)
  end

  it 'should decrease votable score by 1 after creating negative vote' do
    @empty_vote.downvote
    expect(@votable.score).to eq(@old_score - 1)
  end
end
