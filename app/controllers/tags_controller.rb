class TagsController < ApplicationController
  expose :q, :foobar
  expose :tag
  expose :tags { q.result }
  expose :articles { q.result }

  # def index
  #   @q = Tag.ransack(params[:q])
  #   @tags = @q.result
  # end

  # def show
  #   @tag = Tag.find(params[:id])
  #   @q = @tag.articles.ransack(params[:q])
  #   @articles = @q.result
  # end

  def foobar
    return Tag.ransack(params[:q]) if params[:action] == 'index'
    return Tag.find(params[:id]).articles.ransack(params[:q]) if params[:action] == 'show'
  end
end
