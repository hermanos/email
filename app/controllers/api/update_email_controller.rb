require 'net/imap'
class Api::UpdateEmailController < ActionController::Base
	skip_before_filter :verify_authenticity_token	
	respond_to :json
	
	def set_email
		email_address = params[:email_address]
		email_password = params[:email_password]

		imap = @imap = Net::IMAP.new('imap.gmail.com',993,true,nil,true)
		begin
			imap.authenticate('PLAIN', email_address, email_password)
		rescue Net::IMAP::NoResponseError
			render json: { success: false, message: "Invalid email or password"}
			return
		end
		User.first.update_attribute(:email_address, email_address)
		User.first.update_attribute(:email_password, email_password)
		User.first.update_attribute(:stage, 2)
		render json: { success: true, message: "You are now logged in" } 
	end

end