class PrepareUserForDiverse < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.remove :email, :password_digest
    end
  end
end
