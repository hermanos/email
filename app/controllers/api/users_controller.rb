class Api::UsersController < DeviseController
	before_filter :verify_authenticity_token

	def get_stage
		respond_to do |format|
      format.json do
				render json: { json: true,
					             data: { stage: current_user.stage } }
				return
			end
		end		
	end

	def set_stage
		@stage = params[:stage]
		current_user.update_column(:stage, stage)
		respond_to do |format|
      format.json do
				render json: { json: true, 
											 data: { stage: stage } }
				return
			end
		end												
	end

end