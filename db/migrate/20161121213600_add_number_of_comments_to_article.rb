class AddNumberOfCommentsToArticle < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :number_of_comments, :integer, default: 0
  end
end
