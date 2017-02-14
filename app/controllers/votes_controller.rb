class VotesController < ApplicationController
  def create
    @vote = Vote.new(user: current_user, votable_id: params[:votable_id], votable_type: params[:votable_type])
    params[:positive] ? @vote.upvote : @vote.downvote
    @vote.save
    redirect_to :back
  end

  def update
    @vote = Vote.find_by(user: current_user, votable_id: params[:votable_id], votable_type: params[:votable_type])
    @vote.positive ? @vote.downvote : @vote.upvote
    redirect_to :back
  end

  def destroy
    @vote = Vote.find_by(user: current_user, votable_id: params[:votable_id], votable_type: params[:votable_type])
    @vote.destroy
    redirect_to :back
  end
end
