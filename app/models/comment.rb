class Comment < ApplicationRecord
  belongs_to :article, counter_cache: true
  delegate :user, to: :article, allow_nil: true

  validates :author, presence: true, length: { in: 3..200 }
  validates :content, presence: true, length: { in: 1..15_000 }

  def author
    user.name
  end
end
