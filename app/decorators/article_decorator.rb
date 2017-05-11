class ArticleDecorator < Draper::Decorator
  delegate_all
  delegate :class

  def decorated_content
    tags_names = object.content.scan(/#[A-Za-z0-9]+/)
    tags_names.each do |t|
      object.content.gsub!(t, decorate_tag(t))
    end
    object.content.html_safe
  end

  def decorate_tag(name)
    tag = Tag.find_by name: name
    h.link_to(name, tag)
  end
end
