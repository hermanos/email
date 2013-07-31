namespace :mail do
	desc "Synchronizes mail"
	task :sync => :environment do
		User.all.each do |user|
			user.get_all_mail
		end
	end
end