class ArticlesController < ApplicationController
  include ArticlesHelper
  before_action :authorize, only: [:new, :edit, :update, :destroy]

  def index
    params[:smart_buttons] = index_buttons
    if params[:search]
      @articles = Article.where('title LIKE ?', params[:search])
    else
      @articles = Article.all
    end
  end

  def show
    params[:smart_buttons] = show_buttons(params[:id])
    @article = Article.find(params[:id])
    @vote = Vote.find_by votable: @article, user: current_user if current_user
  end

  def new
    @article = Article.new
  end

  def destroy
    @article = Article.find(params[:id])
    if current_user_owns? @article
      @article.destroy
      flash[:success] = 'Article succesfully deleted'
    else
      flash[:danger] = 'You are not permitted to delete this article'
    end
    redirect_to articles_path
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    @article.separated_tags = params[:article][:separated_tags]
    if @article.save
      flash[:success] = 'Article succesfully created'
      redirect_to @article
    else
      render 'new'
    end
  end

  def edit
    @article = Article.find(params[:id])
    unless current_user_owns? @article
      flash[:danger] = 'You are not permitted to edit this article'
      redirect_to articles_path
    end
  end

  def update
    @article = Article.update(params[:id], article_params)
    @article.separated_tags = params[:article][:separated_tags]
    if @article.save
      flash[:success] = 'Article succesfully updated'
      redirect_to @article
    else
      render 'edit'
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :separated_tags)
  end
end
