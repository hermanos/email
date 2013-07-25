class MailSync
	Mail.defaults do
		retriever_method :imap, :address => "imap.gmail.com",
														:port => 993,
														:username => current_user.email_address,
														:password => current_user.email_password,
														:enable_ssl => true
	end
end