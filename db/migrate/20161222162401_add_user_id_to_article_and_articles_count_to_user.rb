class AddUserIdToArticleAndArticlesCountToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :articles, :user, index: true
    # add_foreign_key :articles, :users
    add_column :users, :articles_count, :integer, default: 0
  end
end
