class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name, unique: true, null: false

      t.timestamps
    end

    create_join_table :users, :roles, table_name: :user_roles
  end
end
