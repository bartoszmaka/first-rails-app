class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :redirect_banned_user, except: [:show, :index]
  expose_decorated :comment, parent: :article
  expose_decorated(:article)

  def destroy
    if current_user_owns? comment
      comment.destroy
      flash[:success] = 'Comment succesfully deleted'
    else
      flash[:danger] = 'You are not permitted to delete this comment'
    end
    redirect_to article_path(params[:article_id])
  end

  def create
    comment.user = current_user
    if comment.save
      flash[:success] = 'Comment succesfully created'
      redirect_to article_path(article)
    else
      redirect_to article
    end
  end

  def edit
    unless current_user_owns? comment
      flash[:danger] = 'You are not permitted to edit this comment'
      redirect_to article
    end
  end

  def update
    if comment.update(comment_params)
      flash[:success] = 'Comment succesfully updated'
      redirect_to article_path(article)
    else
      render 'edit'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
