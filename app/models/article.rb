class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  validates :title, presence: true, length: { in: 3..500 }
  validates :content, presence: true, length: { minimum: 5 }
  scope :rnd, -> { order('RANDOM()').first }

  # def self.random_article
  #   Article.order('RANDOM()').first
  # end
end
