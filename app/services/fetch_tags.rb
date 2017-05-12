class FetchTags < ActiveInteraction::Base
  object :article, class: Article

  def execute
    clean_tags
    fetch_tags
  end

  private

  def clean_tags
    article.tags.destroy_all
  end

  def fetch_tags
    names = article.content.scan(/#[A-Za-z0-9]+/)
    names.map! { |x| x.delete('#') }
    names.uniq.each do |name|
      tag = Tag.find_or_create_by(name: name)
      article.tags << tag
    end
  end
end
