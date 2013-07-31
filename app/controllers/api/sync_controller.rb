class Api::SyncController < ActionController::Base

  def mail_defaults(user)
  	unless user.email_address.nil?
  		Mail.defaults do 
  		  retriever_method :imap, :address => "imap.gmail.com", 
  		                          :port => 993, 
  		                          :user_name => user.email_address, 
  		                          :password => user.email_password, 
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
		  receive = Mail.find(mailbox: folder, what: :last, count: 20, order: :desc)
		  receive.each do |mail|
			  if Email.find_by_msg_id(mail.message_id).nil?
			    email = Email.create!(user_id: current_user.id, folder: 'inbox', msg_id: mail.message_id, from: join_address(mail.from),
			    											to: join_address(mail.to), cc: join_address(mail.cc), bcc: nil, subject: mail.subject,
			    											content: mail.parts[0].body.decoded.gsub("\n", ' ').gsub("*", ' '), languate: 'en', status: 'unread')
			  end
			end
		  user.update_attribute(:stage, 3)
		end
	end

	private

	def join_address(address)
	  unless address.nil?
	    address.join(',')     
	  end
	end
	
end