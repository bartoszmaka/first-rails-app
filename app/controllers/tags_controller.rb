class TagsController < ApplicationController
  def index
    @q = Tag.ransack(params[:q])
    @tags = @q.result
  end

  def show
    @tag = Tag.find(params[:id])
    @q = @tag.articles.ransack(params[:q])
    @articles = @q.result
  end
end
