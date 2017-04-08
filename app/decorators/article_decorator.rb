class ArticleDecorator < Draper::Decorator
  delegate_all

  def action_buttons
    h.concat(
      h.link_to('Edit', h.edit_article_path(id))
    )
    h.link_to('Delete', h.article_path(id), method: :delete)
  end
end
