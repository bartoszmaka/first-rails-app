class TagsController < ApplicationController
  expose :q, :foobar
  expose :taggling { Tag.find(params[:id]) }
  expose :tags { q.result }
  expose :articles { q.result }

  def foobar
    # FIXME: this method is kind of workaround
    return Tag.ransack(params[:q]) if params[:action] == 'index'
    return Tag.find(params[:id]).articles.ransack(params[:q]) if params[:action] == 'show'
  end
end
