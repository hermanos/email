class UpdateEmail
	respond_to :json

	def set_email
		@email = JSON.parse(request.body.read)
		current_user.update_column(:email_address, @email["email_address"])
		current_user.update_column(:email_password, @email["email_password"])
		render :json => { :success => true, 
											:data => { :stage => @email["email_address"]} }
	end
end