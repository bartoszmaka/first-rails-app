module Votable
  extend ActiveSupport::Concern

  included do
    has_many :voted_users, through: :votes, source: :user
    has_many :votes, as: :votable do
      def by_user(user)
        find_by(user: user)
      end
    end
  end
end
