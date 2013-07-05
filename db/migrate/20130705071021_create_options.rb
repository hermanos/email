class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.integer :user_id
      t.string :option_value
      t.string :option_name

      t.timestamps
    end
  end
end
