class Api::UploadController < ActionController::Base
	before_filter :verify_authenticity_token

	def create
		respond_to do |format|
			format.json do
				puts params.inspect
				puts current_user.id
				name = params[:file].original_filename
				directory = "#{Rails.root}/public/attachments/#{current_user.id}"
				path = File.join(directory, name)
				unless File.exist?(path)
					FileUtils.mkdir_p(directory)
				end
				File.open(path, "w+") { |f| f.write(params[:file].read.force_encoding('ASCII-8BIT').force_encoding('UTF-8')) }	

				render json: { success: true }
			end
		end
	end
end