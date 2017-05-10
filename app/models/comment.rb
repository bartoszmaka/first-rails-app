class Comment < ApplicationRecord
  include Votable
  belongs_to :article, counter_cache: true
  belongs_to :user, counter_cache: true
  belongs_to :parent, class_name: 'Comment'
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy

  validates :content, presence: true, length: { in: 1..15_000 }

  def author
    user.name
  end
end
