class ArticlesController < ApplicationController
  include ArticlesHelper
  expose(:q) { Article.ransack(params[:q]) }
  expose(:comments_query) { article.comments.ransack(params[:q]) }
  expose(:comments) { comments_query.result }
  expose(:comment) { Comment.new }
  expose_decorated(:article, build_params: :article_params)
  expose(:articles) { q.result }
  before_action :authenticate_user!, except: [:show, :index]
  before_action :redirect_banned_user, except: [:show, :index]

  def destroy
    if current_user_owns? article
      article.destroy
      flash[:success] = 'Article succesfully deleted'
    else
      flash[:danger] = 'You are not permitted to delete this article'
    end
    redirect_to articles_path
  end

  def create
    article.user = current_user
    if article.save
      FetchTags.run(article: article)
      flash[:success] = 'Article succesfully created'
      redirect_to article
    else
      render 'new'
    end
  end

  def edit
    unless current_user_owns? article
      flash[:danger] = 'You are not permitted to edit this article'
      redirect_to articles_path
    end
  end

  def update
    if article.update(article_params)
      FetchTags.run(article: article)
      flash[:success] = 'Article succesfully updated'
      redirect_to article
    else
      render 'edit'
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :user_id, :separated_tags)
  end
end
