class Vote < ApplicationRecord
  # belongs_to :votable, polymorphic: true
  belongs_to :votable, polymorphic: true
  belongs_to :user

  after_save :update_votable_score
  after_destroy :update_votable_score

  validates_uniqueness_of :user, scope: :votable

  def update_votable_score
    value == true ? votable.increment!(:score) : votable.decrement!(:score)
  end
end
