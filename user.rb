require 'logger'
LOGGER = Logger.new(STDOUT)
LOGGER = Logger.new('group1/production.log', 'daily')
LOGGER.datetime_format = "%Y-%m-%d\T%H:%M:%S"
LOGGER.formatter = proc { |severity, datetime, progname, msg|
  "#{datetime}: #{msg}\n"
}

class Card
	attr_reader :number
	attr_accessor :amount
	def initialize(number=CardNoGenerator.next, amount=AmountGenerator.next)
		@number, @amount = number, amount
	end
end
class User
	attr_reader :route, :enterTime, :leaveTime
	def initialize(route, enterTime=1)
		@route, @card = route, Card.new
		@enterTime, @leaveTime = enterTime, enterTime + @route.total_time
		@entered, @left = false
	end

	def finished
		@entered && @left
	end
	def stay_time
		@leaveTime - @enterTime
	end
	def enter(time_passed)
		@actual_enterTime = 
		LOGGER.info sprintf("user entered station #{@route.stations.first.number} with card number #{@card.number} and amount %.2f", @card.amount)
		@entered = true
	end
	def readyToEnter(time_passed)
		!@entered && (time_passed >= @enterTime)
	end
	def leave(time_passed)
		@card.amount = @card.amount - 2
		p "expected: [#{@enterTime}, #{@leaveTime}], actual: [#{@actual_enterTime}, #{time_passed}]"
		LOGGER.info sprintf("user left station #{@route.stations.last.number} with card number #{@card.number} and amount %.2f", @card.amount)
		@left = true
	end
	def readyToLeave(time_passed)
		(@entered && !@left) &&(time_passed >= @leaveTime)
	end
end

class UserFactory
	attr_reader :users
	def initialize(graph, mean_time)
		@graph = graph
		@users = []
		@transfer_users = {}
		@depare_time_generator = DepartureTimeGenerator.new(mean_time)
	end
	def create_users(user_count, transfer_count)
		routes = @graph.routes.find_all{|route| route.lines.length == transfer_count+1}
		return [] if routes.empty?

		@transfer_users[transfer_count] ||= []
		user_count.times.each() do |i|
			user = User.new(random(routes), @depare_time_generator.next)
			@users<<user
			@transfer_users[transfer_count] << user
		end
	end
	def summary
		p "users count: #{users.length}"
		@transfer_users.each_pair do |transfer_count, users|
			p "transfer count: #{transfer_count}, users count: #{users.length}"
		end

		station_most_in
		station_most_out
		station_most_transfer

		last_leave_time = nil
		max_stay_time = nil
		@users.each do |user|
			last_leave_time = user.leaveTime if last_leave_time.nil? || last_leave_time < user.leaveTime
			max_stay_time = user.stay_time if max_stay_time.nil? || max_stay_time < user.stay_time		
		end
		p "max time stayed in subway is #{max_stay_time}"
		p "last one to leave subway is #{last_leave_time}"
	end
	private 
	def random(array)
		array[rand(array.length)]
	end
	def station_most_in
		station_from_users = {}
		@users.each do |user|
			from = user.route.stations.first
			station_from_users[from] ||= [] 
			station_from_users[from] << user
		end
		most_in_stations = []
		most_in_users_count = 0
		station_from_users.each_pair do |station, users|
			if users.length > most_in_users_count
				most_in_users_count = users.length
				most_in_stations = [station]
			elsif users.length == most_in_users_count
				most_in_stations << station
			end
		end
		p "most in stations: #{most_in_stations.collect{|station| station.name}}, users count: #{most_in_users_count}"
	end
	def station_most_out
		station_out_users = {}
		@users.each do |user|
			out = user.route.stations.last
			station_out_users[out] ||= [] 
			station_out_users[out] << user
		end
		most_out_stations = []
		most_out_users_count = 0
		station_out_users.each_pair do |station, users|
			if users.length > most_out_users_count
				most_out_users_count = users.length
				most_out_stations = [station]
			elsif users.length == most_out_users_count
				 most_out_stations << station
			end
		end
		p "most out stations: #{most_out_stations.collect{|station| station.name}}, users count: #{most_out_users_count}"
	end
	def station_most_transfer
		transfer_station_with_users = {}
		@users.each do |user|
			user.route.transfer_stations.each do |station|
				transfer_station_with_users[station] ||= []
				transfer_station_with_users[station] << user
			end
		end
		most_transfered_stations = []
		most_transfered_users_count = 0
		transfer_station_with_users.each_pair do |station, users|
			if users.length > most_transfered_users_count
				most_transfered_users_count = users.length
				most_transfered_stations = [station]
			elsif users.length == most_transfered_users_count
				 most_transfered_stations << station
			end
		end
		p "most transfered stations: #{most_transfered_stations.collect{|station| station.name}}, users count: #{most_transfered_users_count}"

	end
end