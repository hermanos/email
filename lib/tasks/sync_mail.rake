namespace :mail do
	desc "Synchronizes mail"
	task :sync => :environment do
		get_all_mail
	end
end