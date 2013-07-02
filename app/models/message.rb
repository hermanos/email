class Message < ActiveRecord::Base
  attr_accessible :content, :folder_id, :receiver_id, :sender_id, :status
end
