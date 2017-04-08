class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def redirect_banned_user
    if current_user&.banned?
      redirect_back(fallback_location: root_path)
      flash[:danger] = 'You are banned, sorry'
    end
  end
  helper_method :redirect_banned_user

  def current_user_owns?(whatever)
    false if current_user.nil? || current_user.banned?
    current_user == whatever.user || current_user&.admin?
  end
  helper_method :current_user_owns?
end
