class Archivement < ApplicationRecord
  has_many :user_archivements
  has_many :users, through: :user_archivements

  has_attached_file :icon,
                    styles: { medium: '300x300', thumb: '64x64' },
                    default_url: 'archivements/missing.png'

  validates_attachment_content_type :icon, content_type: /\Aimage\/.*\z/
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
end
