class Message < ActiveRecord::Base
  attr_accessible :content, :receiver_id, :sender_id, :subject

  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'

  has_many :sender_tags, class_name: 'Tag', conditions: "owner = 'sender'"
  has_many :receiver_tags, class_name: 'Tag', conditions: "owner = 'receiver'"

  after_create :create_tags

  def create_tags
  	receiver_tags.create(message_id: id, owner: 'receiver', title: INBOX_TAG)
    sender_tags.create(message_id: id, owner: 'sender', title: SENT_TAG) 	
  end

  def has_sender_tag?(tag)
    return sender_tags.map { |t| t.title }.include?(tag)  	
  end

  def has_receiver_tag?(tag)
    return receiver_tags.map { |t| t.title }.include?(tag)  	
  end

end
