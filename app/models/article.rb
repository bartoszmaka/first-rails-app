class Article < ApplicationRecord
  include Votable
  belongs_to :user, counter_cache: true
  has_many :replies, class_name: 'Comment', dependent: :destroy
  has_many :comments, -> { where("depth = 0") }, dependent: :destroy
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
end
