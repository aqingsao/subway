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

		# p "most crowded stations in: #{station_most_in.name}"
		# p "most crowded stations out: #{station_most_out.name}"
	end
	private 
	def random(array)
		array[rand(array.length)]
	end
	def station_most_in
		# station_from_users = {}
		# @users.each do |user|
		# 	from = user.route.first
		# 	station_from_users[from] ||= [] 
		# 	station_from_users[from] << user
		# end
		# most_in = nil
		# station_from_users.each_pair do |station, users|
		# 	most_in = station if most_in.nil? || most_in
		# end
	end
	def station_most_out

	end
end