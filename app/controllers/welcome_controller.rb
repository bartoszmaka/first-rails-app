class WelcomeController < ApplicationController
  def index
    @best_scored_articles = Article.order(score: :desc).limit(4)
  end
end
