class UserDecorator < Drapper::Decorator
  delegate_all
  decorates_association :articles
end
