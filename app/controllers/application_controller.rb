class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id] && User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  def authorize
    if current_user&.banned?
      flash[:danger] = 'You are banned' if current_user&.banned?
      redirect_back(fallback_location: root_path)
    elsif current_user.nil?
      redirect_to '/denied' if !current_user || current_user.banned?
    end
  end

  def current_user_owns?(whatever)
    false if current_user.nil? || current_user.banned?
    current_user == whatever.user || current_user.admin?
  end
  helper_method :current_user_owns?
end
