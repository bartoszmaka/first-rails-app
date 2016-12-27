class Comment < ApplicationRecord
  belongs_to :article, counter_cache: true
  belongs_to :user, counter_cache: true

  validates :content, presence: true, length: { in: 1..15_000 }

  def author
    user.name
  end
end
