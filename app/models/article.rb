class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :article_tags
  has_many :tags, through: :article_tags
  validates :title, presence: true, length: { in: 3..500 }
  validates :content, presence: true, length: { minimum: 5 }
  # scope :rnd, -> { order('RANDOM()').first }

  def separated_tags
    tags_names = []
    tags.each { |tag| tags_names << tag.name }
    tags_names.join(', ')
  end

  def separated_tags=(string)
    return nil if string.nil?
    string.delete(' ').split(',').each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      tags << tag unless tags.include? tag
    end
  end
end
