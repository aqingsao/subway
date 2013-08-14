require File.join(File.dirname(__FILE__), 'user.rb')
require File.join(File.dirname(__FILE__), 'subway.rb')
require File.join(File.dirname(__FILE__), 'helper/helper.rb')

def print_usage_and_throw(msg)
	p "WARNING: #{msg}"
	p "============================"
	p "Usage: ruby main.rb group_name user_count"
	p "where group_name should be either one of group1, group2, group3, group4"
	p "and user_count should be greater than 0"
	p "Example: ruby main.rb group1 100"
	p "============================"
	throw msg
end

print_usage_and_throw "Please provide group name and user count" unless ARGV.length == 2
print_usage_and_throw "group name should be either one of group1, group2, group3, group4" unless ["group1", "group2", "gorup3", "group4"].include? ARGV[0] 
print_usage_and_throw "user_count should be greater than 0" unless ARGV[1].to_i > 0

group_name = ARGV[0]
user_count = ARGV[1].to_i
p "Will generate test data for #{group_name} with #{user_count} users"
p "Test data is generated in #{group_name}/subway.log"

# Init loggers
LOGGER = Logger.new("#{group_name}/subway.log", 'daily')
LOGGER.datetime_format = "%Y-%m-%d\T%H:%M:%S"
LOGGER.formatter = proc { |severity, datetime, progname, msg|
  "#{datetime}: #{msg}\n"
}
SUMMARY_LOGGER = Logger.new("#{group_name}/summary.log", 'daily')

# Loading subway txt
subway = SubwayHelper.load("#{group_name}/subway.txt")
puts "Loading #{group_name}/subway.txt finished..."


# generate graph based on the subway
TIME_PER_STATION = 150
TIME_PER_TRANSFER = 191
graph = Graph.new subway, TIME_PER_STATION, TIME_PER_TRANSFER
puts "Loading subway as graph finished, the maximum transfer count is #{graph.max_transfer_times}"

# create users
factory = UserFactory.new graph, DepartureTimeGenerator.new(user_count)
PortionByTransferGenerator.portions(graph.max_transfer_times, user_count).each_with_index do |portion, index|
	factory.create_users(portion, index)
end

p "Creating users finished, summary information is written into #{group_name}/summary.log..."
factory.summary

# users enter and leave stations
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