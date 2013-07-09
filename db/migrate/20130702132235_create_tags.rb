class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :message_id
      t.string :owner, default: 'sender'
      t.string :title
      t.integer :read, default: nil

      t.timestamps
    end
  end
end
