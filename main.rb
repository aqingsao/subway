require File.join(File.dirname(__FILE__), 'user.rb')
require File.join(File.dirname(__FILE__), 'subway.rb')
require File.join(File.dirname(__FILE__), 'helper/helper.rb')

file = "subway.txt"
subway = SubwayHelper.load(file)

userCount = 1000
factory = UserFactory.new subway
users = []
users += factory.users_with_transfer((userCount * 0.08).ceil, 0)
users += factory.users_with_transfer((userCount * 0.4).ceil, 1)

startTime = Time.new
while(not (remaining = users.find_all{|user| !user.finished}).empty?)
	remaining.each do |user|
		user.enter if user.readyToEnter(startTime)
		user.leave if user.readyToLeave(startTime)
	end
	sleep 1
end