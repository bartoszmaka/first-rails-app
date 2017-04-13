class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def redirect_banned_user
    return unless current_user.nil? || current_user.banned?
    flash[:danger] = 'You are banned, sorry'
    redirect_back(fallback_location: root_path)
  end
  helper_method :redirect_banned_user

  def current_user_owns?(whatever)
    false if current_user.nil? || current_user.banned?
    current_user == whatever.user || current_user&.admin?
  end
  helper_method :current_user_owns?
end
