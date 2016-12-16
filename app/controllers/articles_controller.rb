class ArticlesController < ApplicationController
  include ArticlesHelper
  def index
    params[:smart_buttons] = index_buttons
    @articles = Article.all
  end

  def show
    params[:smart_buttons] = show_buttons(params[:id])
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_path
  end

  def create
    @article = Article.new(article_params)
    @article.separated_tags = params[:article][:separated_tags]
    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.update(params[:id], article_params)
    @article.separated_tags = params[:article][:separated_tags]
    if @article.save
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
