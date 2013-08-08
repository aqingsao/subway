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
	def initialize(from, to, distance, enterTime=1)
		@from, @to, @distance = from, to, distance
		@enterTime, @leaveTime = enterTime, enterTime + distance 
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
	end
	def nonTransfered(count)
		count.times.each_with_object([]) do |i, users|
			fromStation, toStation = randomStationsOn(randomLine)
			distance = @subway.graph.dijkstra(fromStation.index, toStation.index)
			users<<User.new(fromStation, toStation, distance)
		end
	end
	def transferOnce(count)
		count.times.each_with_object([]) do |i, users|
			fromLine = randomLine
			fromStation = randomStation(fromLine) while(fromStation.nil? || fromStation.transfer)

			toLine = random(fromLine.transferableLines)
			toStation = randomStation(toLine) while(toStation.nil? || fromLine.containsStation(toStation.name))

			distance = @subway.graph.dijkstra(fromStation.index, toStation.index)
			users<<User.new(fromStation, toStation, distance)
		end
	end
	def transferTwice(count)
		count.times.each_with_object([]) do |i, users|
			fromLine = randomLine
			fromStation = randomStation(fromLine) while(fromStation.nil? || fromStation.transfer)

			toLine = random(fromLine.transferableLines)
			toStation = randomStation(toLine) while(toStation.nil? || fromLine.containsStation(toStation.name))

			distance = @subway.graph.dijkstra(fromStation.index, toStation.index)
			users<<User.new(fromStation, toStation, distance)
		end
	end
	private 
	def random(array)
		array[rand(array.length)]
	end
	def randomLine
		random(@subway.lines)
	end
	def randomStation(line)
		random(line.stations)
	end

	def randomStationsOn(line)
		from = rand(line.stations.length)
		to = rand(line.stations.length) until to !=nil && to != from
		to = to -2 if(to < from && to >= 2)
		to = to +2 if(to>from && to <line.stations.length-2)
		return line.stations[from], line.stations[to]
	end
end