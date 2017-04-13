class ArticleDecorator < Draper::Decorator
  delegate_all
  delegate :class
end
