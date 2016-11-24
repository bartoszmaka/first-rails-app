module ArticlesHelper
  def tags_separated_by_coma(article)
    tags_names = []
    article.tags.each { |tag| tags_names << tag.name }
    tags_names.join(', ')
  end

  def create_tags_from_string(string)
    string.delete(' ').split(',').each do |tag_name|
      Tag.create(name: tag_name) unless Tag.find_by name: tag_name
    end
  end
end
