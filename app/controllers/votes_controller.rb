class VotesController < ApplicationController
  def new
    votable = Article.find(params[:article_id])
    @vote = Vote.new
    redirect_to votable
  end
  def create
    # binding.pry
    found_votable = Article.find_by(id: params[:article_id]) if params[:article_id]
    found_votable = Comment.find_by(id: params[:comment_id]) if params[:comment_id]
    if current_user.voted? found_votable
      Vote.find_by(user: current_user, votable: found_votable).destroy
    end
    current_user.votes.create do |v|
      v.votable = found_votable
      v.value = true if params[:value] == true
    end
    redirect_to found_votable
  end

  def delete
    found_votable = Comment.find_by(id: params[:id]) if params[:article_id]
    found_votable = Article.find_by(id: params[:id])
    if current_user.voted? found_votable
      Vote.find_by(user: current_user, votable: found_votable).destroy
    end
    redirect_to found_votable
  end
end
