class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :article_tags
  has_many :tags, through: :article_tags
  validates :title, presence: true, length: { in: 3..500 }
  validates :content, presence: true, length: { minimum: 5 }
  scope :rnd, -> { order('RANDOM()').first }

  # def self.random
  #   range_min = Article.first.id
  #   range_max = Article.last.id
  #   article = Article.find_by(id: rand(range_min..range_max)) while article.nil?
  #   article
  # end
end
