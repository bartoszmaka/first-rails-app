class Article < ApplicationRecord
  include Votable
  belongs_to :user, counter_cache: true
  has_many :comments, dependent: :destroy
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags

  validates :title, presence: true, length: { in: 3..500 }
  validates :content, presence: true, length: { minimum: 5 }

  def vote_by_user(user)
    votes.find_by(user: user)
  end

  def author
    user.name
  end

  def separated_tags
    tags_names = []
    tags.each { |tag| tags_names << tag.name }
    tags_names.join(', ')
  end

  def separated_tags=(string)
    return nil if string.nil? || string.match?(/[^a-z0-9 ,]/i)
    tags.destroy_all
    string.strip.split(', ').each do |tag_name|
      t = Tag.find_or_create_by(name: tag_name)
      ArticleTag.find_or_create_by(article_id: id, tag_id: t.id) unless t.nil?
    end
  end
end
