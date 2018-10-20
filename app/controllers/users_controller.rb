class UsersController < ApplicationController
  before_action :ensure_not_logged_in, only: [:new, :create]
  before_action :ensure_logged_in, only: [:index, :show, :update]

  def new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user && @user.save
      log_in_user(@user)
      redirect_to user_url(@user.id)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    if @user
      render :show
    else
      redirect_to users_url
    end
  end

  def index
    @users = User.all
    render :index
  end

  def edit
    @user = User.find(params[:id])
    if @user
      render :edit
    else
      redirect_to users_url
    end
  end

  def update
    @user = User.find(params[:id])
    if @user && @user.update(user_params)
      redirect_to user_url(@user.id)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :location, :house)
  end
end
