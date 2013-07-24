class Api::UsersController < ActionController::Base
	before_filter :authenticate_user!

	respond_to :json

	def get_stage
		render :json => { :success => true,
			                :info => "Registered",
			                :data => { :stage => current_user.stage } }		
	end

	def set_stage(stage)
		current_user.update_column(:stage, stage)
	end

end