class AddStageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stage, :integer, default: 0
  end
end
