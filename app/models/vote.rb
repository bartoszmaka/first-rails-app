class Vote < ApplicationRecord
  # belongs_to :votable, polymorphic: true
  belongs_to :votable, polymorphic: true
  belongs_to :user

  after_save :add_vote_value_to_score
  after_destroy :subtract_vote_value_from_score

  validates_uniqueness_of :user, scope: :votable

  # def self.(user, votable)
  #   Vote.find_by user: user, votable: votable
  # end

  def add_vote_value_to_score
    value == true ? votable.increment!(:score) : votable.decrement!(:score)
  end

  def subtract_vote_value_from_score
    value == false ? votable.increment!(:score) : votable.decrement!(:score)
  end
end
