require 'net/imap'
class Api::UpdateEmailController < ActionController::Base

	def set_email
		email_address = params[:email_address]
		email_password = params[:email_password]
		imap = Net::IMAP.new('imap.gmail.com',993,true,nil,true)
		begin
			imap.authenticate('PLAIN', email_address, email_password)
		rescue Net::IMAP::NoResponseError
			render json: { success: false, message: "Invalid email or password"}
			return
		end
		current_user.update_attribute(:email_address, email_address)
		current_user.update_attribute(:email_password, email_password)
		current_user.update_attribute(:stage, 2)
		render json: { success: true, message: "You are now logged in" } 
	end

end