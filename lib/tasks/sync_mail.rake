namespace :mail do
	desc "Synchronizes mail"
	task :sync => :environment do
		retrieve_mail
	end

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
		@user = User.all
		@user.each do |user|
			if(mail_defaults(user))
			  receive = Mail.find(what: :last, count: 20, order: :desc)
			  receive.each do |mail|
				  if Email.find_by_msg_id(mail.message_id).nil?
				    email = Email.create!(user_id: user.id, folder: 'inbox', msg_id: mail.message_id, from: join_address(mail.from), to: join_address(mail.to), cc: join_address(mail.cc), bcc: nil, subject: mail.subject, content: mail.parts[0].body.decoded.gsub("\n", ' ').gsub("*", ' '), languate: 'en', status: 'unread')
				  else
				    #render json: { success: false, data: receive.from }
				    return
				  end 

				  if email.save
				    #render json: { success: true, data: "Message saved" }
				  end
				end
			  user.update_attribute(:stage, 3)
			end
		end
	end

	def join_address(address)
	  unless address.nil?
	    address.join(',')     
	  end
	end
end