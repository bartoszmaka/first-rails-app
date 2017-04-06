class ArticlesController < ApplicationController
  include ArticlesHelper
  expose(:article)
  expose(:q) { Article.ransack(params[:q]) }
  # expose(:qc) { Comment.ransack(params[:qc]) }
  expose(:articles) { q.result }
  # expose(:comments) { q.result.includes(:comments) }
  expose(:comment) { Comment.new }
  # expose :vote, find: -> { Vote.find_by!(votable: article, user: current_user) }
  before_action :authenticate_user!, except: [:show, :index]
  before_action :deny_banned_user, except: [:show, :index]

  def index
    # @q = Article.ransack(params[:q])
    # @articles = @q.result
    params[:smart_buttons] = index_buttons
  end

  def show
    params[:smart_buttons] = show_buttons(params[:id])
    # binding.pry
    # @article = Article.find(params[:id])
    # @vote = Vote.find_by votable: article, user: current_user if current_user
    # @comment = Comment.new
  end

  # def new
  #   @article = Article.new
  # end

  def destroy
    # @article = Article.find(params[:id])
    if current_user_owns? article
      article.destroy
      flash[:success] = 'Article succesfully deleted'
    else
      flash[:danger] = 'You are not permitted to delete this article'
    end
    redirect_to articles_path
  end

  def create
    # @article = Article.new(article_params)
    article.user = current_user
    if article.save
      article.separated_tags = params[:article][:separated_tags]
      flash[:success] = 'Article succesfully created'
      redirect_to article
    else
      render 'new'
    end
  end

  def edit
    # @article = Article.find(params[:id])
    unless current_user_owns? article
      flash[:danger] = 'You are not permitted to edit this article'
      redirect_to articles_path
    end
  end

  def update
    # @article = Article.update(params[:id], article_params)
    article.separated_tags = params[:article][:separated_tags]
    if article.save
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
