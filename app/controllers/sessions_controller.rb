class SessionsController < ApplicationController
  before_action :ensure_not_logged_in, only: [:new, :create]
  before_action :ensure_logged_in, only: [:destroy]


  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(session_params)
    if @user && @user.save
      log_in_user(@user)
      redirect_to users_url
    else
      flash[:errors] = ['Invalid username or password']
      redirect_to new_session_url
    end
  end

  def destroy
    log_out
  end

  private

  def session_params
    params.require(:user).permit(:username, :password)
  end
end
