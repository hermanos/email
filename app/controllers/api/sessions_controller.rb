class Api::SessionsController < Devise::SessionsController
  skip_before_filter :require_no_authentication
  skip_before_filter :authenticate_user!

  def create
    build_resource
    logger.info "intrat in create"
    logger.info params.inspect
    warden.authenticate!(scope: resource_name, :recall => "#{controller_path}#failure")
    logger.info "dupa warden authenticate"
    respond_to do |format|
      format.json do
        render status: 200,
               json: { success: true,
                          info: "Logged in",
                          data: { 
                                  auth_token: current_user.authentication_token,
                                  stage: current_user.stage
                                }
                      }
        return
      end
    end
  end

  def failure
    logger.info "intrat in failure"
    respond_to do |format|
      format.json do
        render status: 401,
               json: { 
                       success: false,
                       info: "Login Failed",
                       data:  {}
                     }
        return
      end
    end
  end

end