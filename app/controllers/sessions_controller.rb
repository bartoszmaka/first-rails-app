class SessionsController < ApplicationController
  # def new
  # end

  # def create
  #   user = User.find_by(email: params[:session][:email].downcase)
  #   if user && user.authenticate(params[:session][:password])
  #     flash[:info] = "Hello #{user.name}"
  #     session[:user_id] = user.id
  #     redirect_to current_user
  #   else
  #     flash[:danger] = 'Wrong password and email combination'
  #     redirect_to login_path
  #   end
  # end

  # def destroy
  #   flash[:info] = "Bye #{current_user.name}"
  #   session[:user_id] = nil
  #   redirect_to '/login'
  # end
end
