class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id] && User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  def authorize
    redirect_to '/denied' unless current_user
  end

  def current_user_owns?(whatever)
    current_user == whatever.user || current_user.admin?
  end
end
