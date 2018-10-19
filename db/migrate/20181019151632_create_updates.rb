class CreateUpdates < ActiveRecord::Migration[5.2]
  def change
    create_table :updates do |t|
      t.text :user_update_message
      t.timestamps
    end
  end
end
