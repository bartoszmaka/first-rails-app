class Tag < ApplicationRecord
  has_many :article_tags
  has_many :articles, through: :article_tags
  validates :name, presence: true,
                   uniqueness: true,
                   format: { with: /[A-Za-z0-9]+/ },
                   length: { minimum: 1 }

  def self.all_tags_names
    tags = []
    Tag.all.each { |t| tags << t.name }
    tags
  end
end
