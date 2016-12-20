class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find(params[:id])
    @articles = @tag.articles
  end
end
