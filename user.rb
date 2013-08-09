require 'logger'
LOGGER = Logger.new(STDOUT)
# LOGGER = Logger.new('subway.log', 'daily')
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
	@@timePerStation = 2.5 * 60; // 
	def initialize(from, to, route, enterTime=1)
		@from, @to, @route = from, to, route
		@enterTime, @leaveTime = enterTime, enterTime + @route.stations.length 
		@card = Card.new
		@entered, @left = false
	end

	def finished
		@entered && @left
	end
	def enter
		LOGGER.info sprintf("user entered station #{@from.name} with card number #{@card.number} and amount %.2f", @card.amount)
		@entered = true
	end
	def readyToEnter(startTime)
		!@entered && (Time.now - startTime >= @enterTime)
	end
	def leave
		@card.amount = @card.amount - 2
		LOGGER.info sprintf("user left station #{@from.name} with card number #{@card.number} and amount %.2f", @card.amount)
		@left = true
	end
	def readyToLeave(startTime)
		(@entered && !@left) &&(Time.now - startTime >= @leaveTime)
	end
end

class UserFactory
	def initialize(subway = Subway.new)
		@subway = subway
		@graph = Graph.new @subway
	end
	def nonTransfered(count)
		routes = @graph.routes.routes_with_transfer(0)

		count.times.each_with_object([]) do |i, users|
			route = random(routes)
			users<<User.new(route.stations.first, route.stations.last, route)
		end
	end
	def transferOnce(count)
		routes = @subway.routes.routes_with_transfer(1)

		count.times.each_with_object([]) do |i, users|
			route = random(routes)
			users<<User.new(route.stations.first, route.stations.last, route)
		end
	end
	def transferTwice(count)
		routes = @subway.routes.routes_with_transfer(2)

		count.times.each_with_object([]) do |i, users|
			route = random(routes)
			users<<User.new(route.stations.first, route.stations.last, route)
		end
	end
	private 
	def random(array)
		array[rand(array.length)]
	end
end