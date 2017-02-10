class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates_uniqueness_of :user, scope: :votable

  before_destroy :update_votable_score_for_vote_delete

  def upvote
    return if positive == true
    positive ? votable.increment!(:score) : votable.increment!(:score, 2)
    update_attribute :positive, true
  end

  def downvote
    return if positive == false
    positive ? votable.decrement!(:score) : votable.decrement!(:score, 2)
    update_attribute :positive, false
  end

  private

  def update_votable_score_for_vote_delete
    value == true ? votable.decrement!(:score) : votable.increment!(:score)
  end

  def swapvote
    old_value = positive
    update_attribute :positive, !old_value
    old_value == true ? votable.decrement!(:score, 2) : votable.increment!(:score, 2)
  end
end
