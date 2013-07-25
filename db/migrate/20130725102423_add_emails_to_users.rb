class AddEmailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_address, :string
    add_column :users, :email_password, :string
    add_column :users, :email_imap_server, :string
    add_column :users, :email_imap_port, :string
    add_column :users, :email_smtp_server, :string
    add_column :users, :email_smtp_port, :string
    add_column :users, :last_msg_id, :string
  end
end
