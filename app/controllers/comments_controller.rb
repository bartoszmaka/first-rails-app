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
end
