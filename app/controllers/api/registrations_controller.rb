class Api::RegistrationsController < Devise::RegistrationsController
	skip_before_filter :verify_authencity_token

	# respond_to :json

	def create
		build_resource
		respond_to do |format|
			format.json do
				if resource.save
					warden.authenticate!(:scope => resource_name)
					render json: { success: true,
					               info: "Registered",
					                data: { user: resource,
					                        auth_token: current_user.authentication_token } 	}
				else
					render json:  { success: false,
													info: resource.errors,
													data: {} }
				end
			end
		end
	end
end