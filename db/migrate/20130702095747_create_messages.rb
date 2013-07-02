class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.text :content
      t.string :status
      t.integer :folder_id

      t.timestamps
    end
  end
end
