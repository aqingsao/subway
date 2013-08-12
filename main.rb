require File.join(File.dirname(__FILE__), 'user.rb')
require File.join(File.dirname(__FILE__), 'subway.rb')
require File.join(File.dirname(__FILE__), 'helper/helper.rb')

file = "data1/subway.txt"
subway = SubwayHelper.load(file)
# "0: 4701"
# "1: 11753"
# "2: 18810"
# "3: 16201"
# "4: 7315"
# "5: 1378"
# "6: 112"

userCount = 1000
graph = Graph.new subway, 2.5, 3.1
factory = UserFactory.new graph
users = []
users += factory.users_with_transfer((userCount * 0.05).ceil, 0)
users += factory.users_with_transfer((userCount * 0.35).ceil, 1)
users += factory.users_with_transfer((userCount * 0.30).ceil, 2)
users += factory.users_with_transfer((userCount * 0.15).ceil, 3)
users += factory.users_with_transfer((userCount * 0.10).ceil, 4)
users += factory.users_with_transfer((userCount * 0.04).ceil, 5)
users += factory.users_with_transfer((userCount * 0.01).ceil, 6)

startTime = Time.new
while(not (remaining = users.find_all{|user| !user.finished}).empty?)
	remaining.each do |user|
		user.enter if user.readyToEnter(startTime)
		user.leave if user.readyToLeave(startTime)
	end
	sleep 1
end