class Tag < ApplicationRecord
  has_many :article_tags, dependent: :destroy
  has_many :articles, through: :article_tags
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   format: { with: /\A[A-Za-z0-9]+\z/ },
                   length: { minimum: 1 }
end
