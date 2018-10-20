class GoalsController <ApplicationController
  before_action :ensure_logged_in

  def create
    @goal = Goal.new(goal_params)
    @goal.user_id = current_user.id
    @goal.public = public?
    if @goal.save
      redirect_to user_url(@goal.user_id)
    else
      flash[:errors] = @goal.errors.full_messages
      redirect_to user_url(@goal.user_id)
    end
  end

  def edit
    @goal = Goal.find_by(id: params[:id])
    if @goal && ensure_current_user(@goal.user_id)
      render 'users/show'
    else
      redirect_to user_url(params[:user_id])
    end
  end

  def update
    @goal = Goal.find_by(id: params[:id])
    if @goal && @goal.update(goal_params) && ensure_current_user(@goal.user_id)
      @goal.update(public: public?)
      @goal.update(complete: false) if @goal.complete && not_complete?
      # @goal.update(public: public?)
      redirect_to user_url(@goal.user_id)
    elsif @goal
      flash[:errors] = @goal.errors.full_messages
      redirect_to user_url(@goal.user_id)
    else
      redirect_to users_url
    end
  end

  def destroy
    @goal = Goal.find_by(id: params[:id])
    if @goal && @goal.destroy && ensure_current_user(@goal.user_id)
      redirect_to user_url(@goal.user_id)
    elsif @goal
      flash[:errors] = @goal.errors.full_messages
      redirect_to user_url(@goal.user_id)
    else
      redirect_to_users_url
    end
  end

  def show
    @goal = Goal.find(params[:id])
    redirect_to user_url(@goal.user_id)
    # render :show
  end

  def edit
    if ensure_current_user(params[:user_id])
      @goal = Goal.find(params[:id])
      @user = current_user
      render 'users/show'
    else
      # render json: [current_user.id, params[:user_id]]
      redirect_to user_url(current_user.id)
    end
  end

  def complete
    @goal = Goal.find(params[:goal_id])
    if @goal && ensure_current_user(params[:user_id])
      @goal.update(complete: !@goal.complete)
    end
    redirect_to user_url(params[:user_id])
  end

  private

  def public?
    params[:goal][:public] == 'on'
  end

  def not_complete?
    params[:goal][:complete] == 'on'
  end

  def goal_params
    params.require(:goal).permit(:title, :description, :public)
  end


end
