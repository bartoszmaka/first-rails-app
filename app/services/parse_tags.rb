class ParseTags < ApplicationRecord
  object :article, class: Article

  def execute
    return
  end

  private

  def gather_candidades
    candidades = article.content.scan(/#[A-Za-z0-9]+/)
    candidades.each do |c|
      tag = Tag.find_or_create_by(c)
      article.tags << tag
      article.content.gsub(c, h.link_to(c, tag).html_safe)
    end
  end
end
