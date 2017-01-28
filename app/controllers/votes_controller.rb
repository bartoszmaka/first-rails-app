class VotesController < ApplicationController
  def create
    found_votable = Comment.find_by(id: params[:id]) if params[:article_id]
    found_votable = Article.find_by(id: params[:id])
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
