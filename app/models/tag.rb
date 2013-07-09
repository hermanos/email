class Tag < ActiveRecord::Base
  attr_accessible :message_id, :title, :owner, :read

  belongs_to :message
  

end
