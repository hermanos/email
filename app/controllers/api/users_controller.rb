class Api::UsersController < ActionController::Base
	before_filter :authenticate_user!

	respond_to :json

	def get_stage
		render :json => { :success => true,
			                :data => { :stage => current_user.stage } }		
	end

	def set_stage(stage)
		stage_hash = JSON.parse(stage, object_class)
		current_user.update_column(:stage, stage_hash[:stage])
	end

end