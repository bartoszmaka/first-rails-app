class Article < ApplicationRecord
  has_many :comments
  validates :title, presence: true, length: { in: 3..500 }
  validates :content, presence: true, length: { minimum: 5 }
end
