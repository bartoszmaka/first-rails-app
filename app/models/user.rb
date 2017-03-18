class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes
  has_many :articles_voted_on, through: :votes, source: :votable, source_type: 'Article'
  has_many :comments_voted_on, through: :votes, source: :votable, source_type: 'Comment'
  has_and_belongs_to_many :roles, join_table: :user_roles
  has_many :user_archivements
  has_many :archivements, through: :user_archivements

  # attr_accessor :old_password

  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # has_secure_password
  has_attached_file :avatar,
                    styles: { medium: '300x300>', thumb: '100x100' },
                    default_url: 'avatars/missing.png'

  # before_save { self.email = email.downcase }
  after_create { archivements << Archivement.find_or_create_by(name: 'Blogger') }

  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\z}
  validates :name, presence: true, length: { maximum: 50 }
  # validates :email, presence: true,
  #                   length: { maximum: 255 },
  #                   format: { with: VALID_EMAIL_REGEX },
  #                   uniqueness: { case_sensitive: false }
  # validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def recent_resources(time)
    recent = []
    recent << articles.where('updated_at > ?', time)
    recent << comments.where('updated_at > ?', time)
    recent.flatten.sort_by(&:updated_at)
  end

  def admin?
    role?('admin') && !role?('banned')
  end

  def banned?
    role?('banned')
  end

  def ban
    add_role('banned')
  end

  def unban
    remove_role('banned')
  end

  def role?(role_name)
    roles.pluck(:name).include?(role_name)
  end

  def add_role(role_name)
    r = Role.find_or_create_by(name: role_name)
    roles << r unless roles.include? r
  end

  def remove_role(role_name)
    roles.delete(Role.find_by(name: role_name))
  end
end
