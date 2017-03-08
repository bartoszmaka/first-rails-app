class CreateArchivements < ActiveRecord::Migration[5.0]
  def change
    create_table :archivements do |t|
      t.string :name, null: false, index: true
      t.text :description
      t.integer :users_count, default: 0
      t.attachment :icon

      t.timestamps
    end
  end
end
