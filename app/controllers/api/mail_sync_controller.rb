class Api::MailSyncController < ActionController::Base
	Mail.defaults do
		retriever_method :imap, :address => "imap.gmail.com",
														:port => 993,
														:username => 'takehistest',
														:password => 'asdfxxx42',
														:enable_ssl => true
	end

	def create_mail
		@receive = Mail.last

		# @email = Email.create!(user_id: current_user.id, folder: 'inbox', msg_id: @receiver.message_id, from: @receiver.from, to: @receiver.to, cc: @receiver.cc, bcc: nil, subject: @receiver.subject, content: @receiver.body.decoded, language: 'en', status: 'unread')
		@message = Message.create!(sender_id: 1, receiver_id: 1, subject: @receiver.subject, content: @receiver.body.decoded)
	end

end