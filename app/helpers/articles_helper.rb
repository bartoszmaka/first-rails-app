module ArticlesHelper
  def index_buttons
    [
      ActionController::Base.helpers.link_to('New Article', new_article_path)
    ]
  end

  def show_buttons(id)
    [
      ActionController::Base.helpers.link_to('Edit', edit_article_path(id)),
      ActionController::Base.helpers.link_to('Delete', article_path(id), method: :delete)
    ]
  end
end
