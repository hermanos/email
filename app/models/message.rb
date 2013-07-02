class Message < ActiveRecord::Base
  attr_accessible :content, :receiver_id, :sender_id, :subject
end
