class Api::DownloadController < Api::UploadController
	before_filter :verify_authenticity_token

	def send_to_download
		respond_to do |format|
			format.json do
				send_file	"#{Rails.root}/public/attachments/" + current_user.id.to_s + '/' + params[:filename]
			end
		end
	end

end