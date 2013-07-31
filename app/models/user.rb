class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, :password, :username
  has_many :emails
  has_many :contacts
  has_many :sent_messages, :class_name => 'Message', :foreign_key => 'sender_id'
  has_many :received_messages, :class_name => 'Message', :foreign_key => 'receiver_id'
  before_save :ensure_authentication_token

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

  def messages_with_unread_status
    returned_messages = []
    received_messages.each do |message|
      returned_messages << message if message.has_unread_status?
    end
    returned_messages.count
  end

  def mail_defaults
    unless email_address.nil?
      Mail.defaults do 
        retriever_method :imap, :address => "imap.gmail.com", 
                                :port => 993, 
                                :user_name => email_address, 
                                :password => email_password, 
                                :enable_ssl => true
      end
      return true
      else
        return false
    end
  end

  def get_all_mail
    if mail_defaults
      ['inbox', 'sent', 'trash'].each do |folder|
        retrieve_mail(folder)
      end
      update_attribute(:stage, 3)
    end
  end

  def retrieve_mail(folder)
    receive = Mail.find(mailbox: folder, what: :last, count: 20, order: :desc)
    receive.each do |mail|
      if Email.find_by_msg_id(mail.message_id).nil?
        email = Email.create!(user_id: id, folder: 'inbox', msg_id: mail.message_id, from: join_address(mail.from), to: join_address(mail.to),
                              cc: join_address(mail.cc), bcc: nil, subject: mail.subject,
                              content: mail.parts[0].body.decoded.gsub("\n", ' ').gsub("*", ' '),
                              languate: 'en', status: 'unread')
      end
    end
  end
  
  def join_address(address)
    unless address.nil?
      address.join(',')     
    end
  end

end
