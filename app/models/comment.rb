class Comment < ApplicationRecord
  belongs_to :article, counter_cache: true
  validates :author, presence: true, length: { in: 3..200 }
  validates :content, presence: true, length: { in: 1..15_000 }
end
