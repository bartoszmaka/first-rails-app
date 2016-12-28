class CommentsController < ApplicationController
  # include ApplicationHelper
  before_action :authorize, only: [:new, :edit, :update, :destroy]

  def index
    @article = Article.find(params[:article_id])
    @comments = @article.comments
  end

  def destroy
    @comment = Comment.find(params[:id])
    if current_user_owns? @comment
      @comment.destroy
      flash[:success] = 'Comment succesfully deleted'
    else
      flash[:danger] = 'You are not permitted to delete this comment'
    end
    redirect_to article_path(params[:article_id])
  end

  def new
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new
  end

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:success] = 'Comment succesfully created'
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  def edit
    @article = Article.find(params[:article_id])
    @comment = Comment.find(params[:id])
    unless current_user_owns? @comment
      flash[:danger] = 'You are not permitted to edit this comment'
      redirect_to @article
    end
  end

  def update
    @article = Article.find(params[:article_id])
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    if @comment.save
      flash[:success] = 'Comment succesfully updated'
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
