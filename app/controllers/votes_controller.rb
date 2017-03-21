class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :deny_banned_user, except: [:show, :index]

  def create
    @vote = Vote.new(user: current_user, votable_id: params[:votable_id], votable_type: params[:votable_type])
    params[:positive] ? @vote.upvote : @vote.downvote
    @vote.save
    redirect_back(fallback_location: root_path)
    # redirect_to :back
  end

  def update
    @vote = Vote.find_by(user: current_user, votable_id: params[:votable_id], votable_type: params[:votable_type])
    @vote.positive ? @vote.downvote : @vote.upvote
    redirect_back(fallback_location: root_path)
    # redirect_to :back
  end

  def destroy
    @vote = Vote.find_by(user: current_user, votable_id: params[:votable_id], votable_type: params[:votable_type])
    @vote.destroy
    redirect_back(fallback_location: root_path)
    # redirect_to :back
  end
end
