class AddArticlesCountToTags < ActiveRecord::Migration[5.0]
  def change
    add_column :tags, :articles_count, :integer, default: 0
  end
end
