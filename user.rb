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
		LOGGER.info sprintf("user entered station #{@route.stations.first.name} with card number #{@card.number} and amount %.2f", @card.amount)
		@entered = true
	end
	def readyToEnter(startTime)
		!@entered && (Time.now - startTime >= @enterTime)
	end
	def leave
		@card.amount = @card.amount - 2
		LOGGER.info sprintf("user left station #{@route.stations.last.name} with card number #{@card.number} and amount %.2f", @card.amount)
		@left = true
	end
	def readyToLeave(startTime)
		(@entered && !@left) &&(Time.now - startTime >= @leaveTime)
	end
end

class UserFactory
	def initialize(graph)
		@graph = graph
	end
	def users_with_transfer(user_count, transfer_count)
		routes = @graph.routes.find_all{|route| route.lines.length == transfer_count+1}
		return [] if routes.empty?

		user_count.times.each_with_object([]) do |i, users|
			route = random(routes)
			users<<User.new(route)
		end
	end
	private 
	def random(array)
		array[rand(array.length)]
	end
end