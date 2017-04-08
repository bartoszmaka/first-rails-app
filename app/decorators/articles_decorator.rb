class ArticlesDecorator < Draper::CollectionDecorator
  delegate :order
end
