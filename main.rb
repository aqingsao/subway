require File.join(File.dirname(__FILE__), 'user.rb')
require File.join(File.dirname(__FILE__), 'subway.rb')
require File.join(File.dirname(__FILE__), 'helper/helper.rb')

file = "subway.txt"
subway = SubwayHelper.loadSubway(file)

userCount = 1000
factory = UserFactory.new subway
users = factory.nonTransfered((userCount * 0.08).ceil)
users = factory.transferOnce((userCount * 0.4).ceil)

startTime = Time.new
while(not (remaining = users.find_all{|user| !user.finished}).empty?)
	remaining.each do |user|
		user.enter if user.readyToEnter(startTime)
		user.leave if user.readyToLeave(startTime)
	end
	sleep 1
end