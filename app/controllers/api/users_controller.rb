class Api::UsersController < DeviseController

	before_filter :authenticate_user!

	respond_to :json

	def get_stage
		render :json => { :success => true,
			                :data => { :stage => current_user.stage } }		
	end

	def set_stage
		@stage = JSON.parse(request.body.read)
		current_user.update_column(:stage, @stage["stage"])
		render :json => { :success => true, 
											:data => { :stage => @stage["stage"]} }
	end

end