class WelcomeController < ApplicationController
  def index
    @best_scored_articles = Article.order(score: :desc).limit(4)
    @articles = Article.order(created_at: :desc).limit(25)
  end
end
