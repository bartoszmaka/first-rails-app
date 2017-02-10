class Comment < ApplicationRecord
  include Votable
  belongs_to :article, counter_cache: true
  belongs_to :user, counter_cache: true
  has_many :votes, as: :votable

  validates :content, presence: true, length: { in: 1..15_000 }

  def author
    user.name
  end
end
