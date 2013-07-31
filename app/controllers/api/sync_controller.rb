class Api::SyncController < ActionController::Base
	before_filter :verify_authenticity_token

  def mail_defaults
  	unless user.email_address.nil?
  		Mail.defaults do 
  		  retriever_method :imap, :address => "imap.gmail.com", 
  		                          :port => 993, 
  		                          :user_name => current_user.email_address, 
  		                          :password => current_user.email_password, 
  		                          :enable_ssl => true
  		end
  		return true
  		else
  			return false
  	end
  end

	def retrieve_mail
		folder = params[:folder]
		if(mail_defaults(current_user))
		  receive = Mail.find(mailbox: set_folder(folder), what: :last, count: 20, order: :desc)
		  receive.each do |mail|
			  if Email.find_by_msg_id(mail.message_id).nil?
			    email = Email.create!(user_id: current_user.id, folder: folder, msg_id: mail.message_id, from: join_address(mail.from),
			    											to: join_address(mail.to), cc: join_address(mail.cc), bcc: nil, subject: mail.subject,
			    											content: mail.parts[0].body.decoded.gsub("\n", ' ').gsub("*", ' '), languate: 'en', status: 'unread')
			  end
			end
		  user.update_attribute(:stage, 3)
		end
	end

	private

	def set_folder(folder)
		if folder.downcase == 'inbox'
			return
		elsif folder.downcase == 'sent'
			folder = '[Gmail]/' + folder + ' Mail'
		else
			folder = '[Gmail]/' + folder.downcase.humanize
		end
	end

	def join_address(address)
	  unless address.nil?
	    address.join(',')     
	  end
	end
	
end