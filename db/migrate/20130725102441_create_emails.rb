class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.integer :user_id
      t.string :folder
      t.string :msg_id
      t.string :from
      t.string :to
      t.string :cc
      t.string :bcc
      t.string :subject
      t.text :content
      t.string :languate
      t.string :status

      t.timestamps
    end
  end
end
