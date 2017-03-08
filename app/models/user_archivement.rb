class UserArchivement < ApplicationRecord
  belongs_to :user
  belongs_to :archivement, counter_cache: :users_count
  validates_uniqueness_of :archivement_id, scope: :user_id
end
