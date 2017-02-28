class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :user_roles

  validates :name, presence: true,
                   length: { minimum: 1 },
                   uniqueness: { case_sensitive: false }
end
