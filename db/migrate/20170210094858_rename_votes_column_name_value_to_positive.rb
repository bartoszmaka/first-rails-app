class RenameVotesColumnNameValueToPositive < ActiveRecord::Migration[5.0]
  def change
    rename_column :votes, :value, :positive
  end
end
