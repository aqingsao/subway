require File.join(File.dirname(__FILE__), 'user.rb')
require File.join(File.dirname(__FILE__), 'subway.rb')
require File.join(File.dirname(__FILE__), 'helper/helper.rb')

file = "data1/subway.txt"
subway = SubwayHelper.load(file)
puts "Loading subway.txt finished..."
# "0: 4701"
# "1: 11753"
# "2: 18810"
# "3: 16201"
# "4: 7315"
# "5: 1378"
# "6: 112"

userCount = 1032
time_per_station = 150
time_per_transfer = 191
mean_time_to_departure = 5 * 60
graph = Graph.new subway, time_per_station, time_per_transfer
puts "Loading subway as graph finished..."

factory = UserFactory.new graph, mean_time_to_departure
factory.create_users((userCount * 0.05).ceil, 0)
factory.create_users((userCount * 0.35).ceil, 1)
factory.create_users((userCount * 0.30).ceil, 2)
factory.create_users((userCount * 0.15).ceil, 3)
factory.create_users((userCount * 0.10).ceil, 4)
factory.create_users((userCount * 0.04).ceil, 5)
factory.create_users((userCount * 0.01).ceil, 6)

p "Creating users finished, here's a quicks summary..."
factory.summary

startTime = Time.new
while(not (remaining = factory.users.find_all{|user| !user.finished}).empty?)
	remaining.each do |user|
		user.enter if user.readyToEnter(startTime)
		user.leave if user.readyToLeave(startTime)
	end
	sleep 1
end
p "All finished"