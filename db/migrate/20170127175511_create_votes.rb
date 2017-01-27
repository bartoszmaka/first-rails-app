class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.belongs_to :user, index: true
      t.belongs_to :votable, polymorphic: true, index: true
      t.boolean :value, default: false

      t.timestamps
    end
    add_column :articles, :score, :integer, default: 0
    add_column :comments, :score, :integer, default: 0
  end
end
