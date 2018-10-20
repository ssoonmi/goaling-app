class CommentsController < ApplicationController
  before_action :ensure_logged_in

  def create
    @comment = Comment.new(comment_params)
    if params[:goal_id]
      @comment.commentable_id = params[:goal_id]
      @comment.commentable_type = 'Goal'
    else
      @comment.commentable_id = params[:user_id]
      @comment.commentable_type = 'User'
    end
    @comment.author_id = current_user.id
    if @comment.save
      redirect_to user_url(params[:user_id])
    else
      flash[:errors] = @comment.errors.full_messages
      redirect_to user_url(params[:user_id])
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    if @comment
      render :edit
    else
      redirect_to users_url
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if !@comment
      redirect_to users_url
    end
    url = commentable_url(@comment)
    if @comment && @comment.author_id == current_user.id && @comment.update(comment_params)
      redirect_to url
    elsif @comment
      flash[:errors] = @comment.errors.full_messages
      redirect_to url
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if !@comment
      redirect_to users_url
    end
    url = commentable_url(@comment)
    if @comment.author_id == current_user.id
      @comment.destroy
    end
    redirect_to url
  end


  private

  def commentable_url(comment)
    url = ''
    if comment.commentable_type == 'User'
      url = user_url(id: comment.commentable_id)
    else
      goal = Goal.find(comment.commentable_id)
      url = user_goal_url(user_id: goal.user_id, id: goal.id)
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
