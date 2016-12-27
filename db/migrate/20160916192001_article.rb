class Article < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.references :user, foreign_key: true
      t.integer :comments_count, default: 0

      t.timestamps
    end
  end
end
