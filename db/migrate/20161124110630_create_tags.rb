class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :articles_count, default: 0

      t.timestamps
    end
  end
end
