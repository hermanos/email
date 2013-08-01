class Api::SendController < Api::SyncController
	before_filter :verify_authenticity_token

	def send_mail
		# mail_params = {
		# 								to: params[:email][:to],
		# 								subject: params[:email][:subject],
		# 								content: params[:email][:content]
		# 							}
		settings = {
									address: 'smtp.gmail.com',
									port: 587,
									user_name: current_user.email_address,
									password: current_user.email_password,
									authentication: 'plain',
									enable_starttls_auto: true
							 }

		set_defaults(settings)
		mail = Mail.new
		mail.from 		settings[:user_name]
		mail.to				params[:email][:to]
		mail.subject 	params[:email][:subject]
		mail.body			params[:email][:content]
		puts params[:email][:attach]
		unless params[:email][:attach].nil?
			mail.add_file Rails.root.to_s + '/attachments/' + current_user.id.to_s + '/' + params[:email][:attach].to_s
		end
		mail.deliver
		retrieve_mail('sent')
	end

	def set_defaults(settings)
		Mail.defaults do
			delivery_method :smtp, settings
		end
	end

end