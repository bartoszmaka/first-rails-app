class AddTablesRelations < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :article_id, :integer, index: true
    add_foreign_key :comments, :articles
    add_column :comments, :user_id, :integer, index: true
    add_foreign_key :comments, :users
    add_column :articles, :user_id, :integer, index: true
    add_foreign_key :articles, :users
    add_column :articles, :comments_count, :integer, default: 0
    add_column :users, :articles_count, :integer, default: 0
    add_column :users, :comments_count, :integer, default: 0
  end
end
