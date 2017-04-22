class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes
  has_many :articles_voted_on, through: :votes, source: :votable, source_type: 'Article'
  has_many :comments_voted_on, through: :votes, source: :votable, source_type: 'Comment'
  has_and_belongs_to_many :roles, join_table: :user_roles
  has_many :user_archivements
  has_many :archivements, through: :user_archivements

  has_attached_file :avatar,
                    styles: { medium: '300x300>', thumb: '100x100' },
                    default_url: 'avatars/missing.png'

  before_create { self.name = name_from_email if name.nil? }
  after_create { archivements << Archivement.find_or_create_by(name: 'Blogger') }

  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\z}

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

  private

  def name_from_email
    email.split('@').first
  end
end
