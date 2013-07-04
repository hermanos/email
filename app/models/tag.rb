class Tag < ActiveRecord::Base
  attr_accessible :message_id, :title, :owner

  belongs_to :message
  

end
