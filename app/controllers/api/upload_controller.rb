class Api::UploadController < ActionController::Base
	before_filter :verify_authenticity_token

	def create
		name = params[:upload][:file].original_filename
		directory = "public/attachments/#{current_user.id}"
		path = File.join(directory, name)
		File.open(path, "w+") { |f| f.write(params[:upload][:file].read) }	
	end
end