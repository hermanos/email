class Api::SessionsController < Devise::SessionsController
	 skip_before_filter :verify_authenticity_token

  def create
    sign_in(resource_name, resource)
    respond_to do |format|
      format.json do
        render status: 200,
               json: { success: true,
                          info: "Logged in",
                          data: { 
                                  auth_token: current_user.authentication_token 
                                  stage: current_user.stage
                                }
                      }
      end
    end
  end

  def failure
    respond_to do |format|
      format.json do
        render status: 401,
               json: { 
                       success: false,
                       info: "Login Failed",
                       data:  {}
                     }
      end
    end
  end

end