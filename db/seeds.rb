# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

andrei = User.create!(email: 'andrei@yahoo.com', password: 'aaaaaaaa')
lavinia = User.create!(email: 'lavinia@yahoo.com', password: 'aaaaaaaa')
daniela = User.create!(email: 'daniela@yahoo.com', password: 'aaaaaaaa')

users = [andrei, lavinia, daniela]
100.times do |i|
	sender = users.sample
	receiver = (users - [sender]).sample

	message = Message.create!(sender_id: sender.id, receiver_id: receiver.id, subject: "Subject #{i}", content: "Creation is beautiful, lorem ipsum #{i}" )
end

