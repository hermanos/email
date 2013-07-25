class Email < ActiveRecord::Base
  attr_accessible :bcc, :cc, :content, :folder, :from, :languate, :msg_id, :status, :subject, :to, :user_id
end
