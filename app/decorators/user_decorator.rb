class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :articles

  def roles_list
    if object.roles.empty?
      h.concat(h.content_tag(:p, 'user'))
    else
      object.roles.each { |role| h.concat(h.content_tag(:p, role.name)) }
    end
  end
end
