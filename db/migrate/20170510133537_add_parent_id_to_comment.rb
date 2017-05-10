class AddParentIdToComment < ActiveRecord::Migration[5.0]
  def change
    add_reference :comments, :parent, index: true
  end
end
