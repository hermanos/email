class Message < ActiveRecord::Base
  attr_accessible :content, :receiver_id, :sender_id, :subject

  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'

  has_many :sender_tags, class_name: 'Tag', conditions: "owner = 'sender'"
  has_many :receiver_tags, class_name: 'Tag', conditions: "owner = 'receiver'"

end
