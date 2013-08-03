class Api::SyncController < ActionController::Base
	before_filter :verify_authenticity_token

  def mail_defaults
  	unless current_user.email_address.nil?
  		settings = {
  									:address => "imap.gmail.com", 
  									:port => 993, 
  									:user_name => current_user.email_address, 
  									:password => current_user.email_password, 
  									:enable_ssl => true
  							 }
  		Mail.defaults do 
  		  retriever_method :imap, settings
  		end
  		return true
  		else
  			return false
  	end
  end

	def retrieve_mail(folder = nil)
		folder ||= params[:folder]
		if(mail_defaults)
		  receive = Mail.find(mailbox: set_folder(folder), what: :last, count: 20, order: :desc)
		  receive.each do |mail|
		  	check_attachment(mail)
			  if Email.find_by_msg_id(mail.message_id).nil?
			    email = Email.create!(user_id: current_user.id, folder: folder, msg_id: mail.message_id, from: join_address(mail.from),
			    											to: join_address(mail.to), cc: join_address(mail.cc), bcc: nil, subject: mail.subject,
			    											content: get_body(mail), languate: 'en', status: 'unread', attachment: check_attachment(mail))
			  end
			end
		  current_user.update_attribute(:stage, 3)
		  respond_to do |format|
		  	format.json do
		  		render json: { stage: current_user.stage }
		  	end
		  end
		end
	end

	private

	def check_attachment(mail)
		unless mail.attachments.nil?
			mail.attachments.each do |attachment|
				size = defined?(attachment.decoded) ? attachment.decoded.length : attachment.size
				if size < 2.097e6 && attachment.content_type.start_with?('audio/')
					filename = attachment.filename
					unless File.exist?("#{Rails.root}/public/attachments/" + current_user.id.to_s + '/' + filename)
						FileUtils.mkdir_p("#{Rails.root}/public/attachments/#{current_user.id}")
					end
					File.open("#{Rails.root}/public/attachments/" + current_user.id.to_s + '/' + filename, "w+b", 0644) { |f| f.write attachment.body.decoded }
					return filename
				end
			end
		end
		return nil
	end

	def set_folder(folder)
		if folder.downcase == 'inbox'
			return
		elsif folder.downcase == 'sent'
			folder = '[Gmail]/' + folder.humanize + ' Mail'
		else
			folder = '[Gmail]/' + folder.downcase.humanize
		end

	end

	def get_body(mail)
    if mail.parts[0].nil?
      mail.body.decoded.gsub("\n", ' ').gsub("*", ' ')
    else
      mail.parts[0].body.decoded.gsub("\n", ' ').gsub("*", ' ')
    end
  end

	def join_address(address)
	  unless address.nil?
	    address.join(',')     
	  end
	end
	
end