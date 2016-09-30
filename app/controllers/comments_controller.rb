class CommentsController < ApplicationController
  def index
    @article = Article.find(params[:article_id])
    @comments = @article.comments
  end

  def destroy
    # @article = Article.find(params[:article_id])
    @comment = Comment.find(params[:id])
    @comment.delete
    redirect_to article_path(params[:article_id])
  end

  def new
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new
  end

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(comment_params)
    if @comment.valid?
      @comment.save
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:author, :content)
  end
end
