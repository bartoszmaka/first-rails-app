class Tag < ApplicationRecord
  has_many :article_tags, dependent: :destroy
  has_many :articles, through: :article_tags
  validates :name, presence: true,
                   uniqueness: true,
                   format: { with: /\A[A-Za-z0-9]+\z/ },
                   length: { minimum: 1 }

  def self.all_tags_names
    tags = []
    Tag.all.each { |t| tags << t.name }
    tags
  end

  def self.exist_like?(name)
    !!Tag.find_by(name: name)
  end
end
