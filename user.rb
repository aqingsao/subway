require 'logger'
LOGGER = Logger.new(STDOUT)
LOGGER = Logger.new('data1/subway.log', 'daily')
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
	attr_reader :route
	def initialize(route, enterTime=1)
		@route, @card = route, Card.new
		@enterTime, @leaveTime = enterTime, enterTime + @route.total_time
		@entered, @left = false
	end

	def finished
		@entered && @left
	end
	def enter
		LOGGER.info sprintf("user entered station #{@route.stations.first.number} with card number #{@card.number} and amount %.2f", @card.amount)
		@entered = true
	end
	def readyToEnter(startTime)
		!@entered && (Time.now - startTime >= @enterTime)
	end
	def leave
		@card.amount = @card.amount - 2
		LOGGER.info sprintf("user left station #{@route.stations.last.number} with card number #{@card.number} and amount %.2f", @card.amount)
		@left = true
	end
	def readyToLeave(startTime)
		(@entered && !@left) &&(Time.now - startTime >= @leaveTime)
	end
end

class UserFactory
	attr_reader :users
	def initialize(graph)
		@graph = graph
		@users = []
		@transfer_users = {}
	end
	def create_users(user_count, transfer_count)
		routes = @graph.routes.find_all{|route| route.lines.length == transfer_count+1}
		return [] if routes.empty?

		@transfer_users[transfer_count] ||= []
		user_count.times.each() do |i|
			user = User.new(random(routes))
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
		station_transfer
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
	def station_transfer
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