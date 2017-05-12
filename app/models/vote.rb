class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates_uniqueness_of :user, scope: :votable

  before_destroy :update_votable_score_for_vote_delete

  def upvote
    return if positive && persisted? || invalid?
    persisted? ? votable.increment!(:score, 2) : votable.increment!(:score)
    update_attribute :positive, true
  end

  def downvote
    return if !positive && persisted? || invalid?
    persisted? ? votable.decrement!(:score, 2) : votable.decrement!(:score)
    update_attribute :positive, false
  end

  private

  def update_votable_score_for_vote_delete
    positive == true ? votable.decrement!(:score) : votable.increment!(:score)
  end
end
