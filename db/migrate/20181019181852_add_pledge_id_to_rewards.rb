class AddPledgeIdToRewards < ActiveRecord::Migration[5.2]
  def change
    add_reference :rewards, :pledge, foreign_key: true
  end
end
