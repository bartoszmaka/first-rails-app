class VotesController < ApplicationController
  def create
    found_votable = Article.find_by(id: params[:article_id]) if params[:article_id]
    found_votable = Comment.find_by(id: params[:comment_id]) if params[:comment_id]
    if current_user.voted? found_votable
      Vote.find_by(user: current_user, votable: found_votable).destroy
    end
    current_user.votes.create do |v|
      v.votable = found_votable
      v.value = true if params[:value] == 'true'
    end
    redirect_to :back
  end

  def destroy
    found_votable = Article.find_by(id: params[:article_id]) if params[:article_id]
    found_votable = Comment.find_by(id: params[:comment_id]) if params[:comment_id]
    if current_user.voted? found_votable
      Vote.find_by(user: current_user, votable: found_votable).destroy
    end
    redirect_to :back
  end
end
