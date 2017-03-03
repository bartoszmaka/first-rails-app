class UsersController < ApplicationController
  before_action :authorize, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_create_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'Account succesfully created'
      redirect_to current_user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    # @user.update_attributes(avatar: user_update_params)
    # binding.pry
    @user.avatar = params[:user][:avatar]
    if @user.save
      flash[:success] = 'Profile succesfully updated'
      redirect_to @user
    else
      flash[:danger] = 'There were problems with updating profile'
      render 'edit'
    end
  end

  private

  def user_create_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:avatar)
  end
end
