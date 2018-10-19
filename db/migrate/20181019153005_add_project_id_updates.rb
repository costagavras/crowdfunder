class AddProjectIdUpdates < ActiveRecord::Migration[5.2]
  def up
      add_column :updates, :project_id, :integer
  end

  def down
      remove_column :updates, :project_id, :integer
  end
end
