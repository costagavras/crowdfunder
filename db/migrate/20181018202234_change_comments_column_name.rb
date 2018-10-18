class ChangeCommentsColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :comments, :comment, :review
  end
end
