class Tag < ApplicationRecord
  has_many :article_tags
  has_many :articles, through: :article_tags
  validates :name, presence: true,
                   uniqueness: true,
                   format: { with: /[A-Za-z0-9]+/ },
                   length: { minimum: 1 }
end
