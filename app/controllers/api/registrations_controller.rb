class Api::RegistrationsController < Devise::RegistrationsController
	before_filter :verify_authencity_token, except: :create

	# respond_to :json

	def create
		build_resource
		respond_to do |format|
			format.json do
				if resource.save
					sign_in(resource_name, resource)
					render json: { success: true,
					               info: "Registered",
					                data: { user: resource,
					                        auth_token: current_user.authentication_token,
					                        stage: current_user.stage } 	}
					return
				else
					render json:  { success: false,
													info: resource.errors,
													data: {} }
					return
				end
			end
		end
	end
end