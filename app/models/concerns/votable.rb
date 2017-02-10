module Votable
  extend ActiveSupport::Concern

  included do
    has_many :voted_users, through: :votes, source: :user
  end
end
