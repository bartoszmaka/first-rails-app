class ArticleDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :comments

  # def comments_by_score
  #   comments.ransack(score: :desc).result
  # end
end
