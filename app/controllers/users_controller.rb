class UsersController < ApplicationController
  expose(:q) { User.ransack(params[:q]) }
  expose(:users) { q.result }
  expose(:latest_activity) { user.recent_resources(7.days.ago) }
  expose_decorated(:user, build_params: :user_params)
  before_action :authenticate_user!, except: [:show]
end
