class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :articles
end
