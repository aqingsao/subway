require File.join(File.dirname(__FILE__), 'user.rb')
require File.join(File.dirname(__FILE__), 'subway.rb')
require File.join(File.dirname(__FILE__), 'helper/helper.rb')

file = "group1/subway.txt"
subway = SubwayHelper.load(file)
puts "Loading subway.txt finished..."
# "0: 4701"
# "1: 11753"
# "2: 18810"
# "3: 16201"
# "4: 7315"
# "5: 1378"
# "6: 112"

user_count = 100
time_per_station = 150
time_per_transfer = 191
graph = Graph.new subway, time_per_station, time_per_transfer
puts "Loading subway as graph finished, the maximum transfer count is #{graph.max_transfer}"


factory = UserFactory.new graph, DepartureTimeGenerator.new(user_count)
[[0, 0.05], [1, 0.35], [2, 0.30], [3, 0.15], [4, 0.10], [5, 0.04], [6, 0.01]].each do |transfer_count, portion|
	factory.create_users((user_count * portion).ceil, transfer_count)
end

p "Creating users finished, here's a quicks summary..."
factory.summary

start_time = Time.new
while(not (remaining = factory.users.find_all{|user| !user.finished}).empty?)
	time_passed = Time.new - start_time
	remaining.each do |user|
		user.enter(time_passed) if user.readyToEnter(time_passed)
		user.leave(time_passed) if user.readyToLeave(time_passed)
	end
	sleep 1
end
p "All finished"