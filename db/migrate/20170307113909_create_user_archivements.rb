class CreateUserArchivements < ActiveRecord::Migration[5.0]
  def change
    create_table :user_archivements do |t|
      t.belongs_to :user, index: true
      t.belongs_to :archivement, index: true
    end
  end
end
