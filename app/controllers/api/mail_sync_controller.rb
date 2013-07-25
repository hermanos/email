class Api::MailSyncController < ActionController::Base
	Mail.defaults do retriever_method :imap, :address => "imap.gmail.com", :port => 993, :user_name => User.first.email_address, :password => User.first.email_password, :enable_ssl => true
	end

	def create_mail
		receive = Mail.last

		unless receive.from.nil?
			from = receive.from.join(',')
		else
			to = nil			
		end
		unless receive.to.nil?
			to = receive.to.join(',')
		else
			to = nil
		end
		unless receive.cc.nil?
			cc = receive.cc.join(',')
		else
			to = nil			
		end

		if Email.find_by_msg_id(receive.message_id).nil?
			email = Email.create!(user_id: User.first.id, folder: 'inbox', msg_id: receive.message_id, from: receive.from.join(','), to: receive.to.join(','), cc: receive.cc.join(','), bcc: nil, subject: receive.subject, content: receive.body.decoded, languate: 'en', status: 'unread')
		else
			render json: { success: false, data: receive.from }
			return
		end	

		if email.save
			render json: { success: true, data: "Message saved" }
		end

		# message = Message.create!(sender_id: 1, receiver_id: 1, subject: receive.subject, content: receive.body.decoded)
		# if message.save
		# 	render json: { success: true, data: "Message Saved" }
		# end
	end

end