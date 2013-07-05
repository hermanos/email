class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, :password, :username
  
  has_many :sent_messages, :class_name => 'Message', :foreign_key => 'sender_id'
  has_many :received_messages, :class_name => 'Message', :foreign_key => 'receiver_id'
  has_many :options

  after_create :create_options

  def create_options
    DEFAULT_OPTIONS.each do |option|
      Option.create!(user_id: id, option_name: option[0], option_value: option[1] )
    end
  end

  def messages
  	(sent_messages + received_messages).uniq  	
  end

  def messages_with_sender_tag(tag)
    returned_messages = []
    sent_messages.each do |message|
      returned_messages << message if message.has_sender_tag?(tag)
    end
    returned_messages
  end

  def messages_with_receiver_tag(tag)
    returned_messages = []
    received_messages.each do |message|
      returned_messages << message if message.has_receiver_tag?(tag)
    end
    returned_messages
  end

  def own_messages_with_tag(tag)
    (messages_with_sender_tag(tag) + messages_with_receiver_tag(tag)).uniq
  end

end
