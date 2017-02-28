class User < ApplicationRecord
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes
  has_many :articles_voted_on, through: :votes, source: :votable, source_type: 'Article'
  has_many :comments_voted_on, through: :votes, source: :votable, source_type: 'Comment'
  has_and_belongs_to_many :roles, join_table: :user_roles

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_secure_password
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  def admin?
    r = roles.pluck(:name)
    r.include?('admin') && !r.include?('banned')
  end

  def ban
    add_role('banned')
  end

  def unban
    remove_role('banned')
  end

  def add_role(role_name)
    r = Role.find_or_create_by(name: role_name)
    roles << r unless roles.include? r
  end

  def remove_role(role_name)
    roles.delete(Role.find_by(name: role_name))
  end
end
