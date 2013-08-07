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
	def initialize(from, to, enterTime=1, card=Card.new)
		@card, @from, @to, @offTime = card, from, to, enterTime
		@entered, @left = false
		@enterTime, @leaveTime = enterTime, enterTime + 3 
	end

	def finished
		@entered && @left
	end
	def enter
		LOGGER.info "user entered station #{@from.name} with card number #{@card.number} and amount #{@card.amount}"
		@entered = true
	end
	def readyToEnter(startTime)
		!@entered && (Time.now - startTime >= @enterTime)
	end
	def leave
		@card.amount = @card.amount - 2
		LOGGER.info "user left station #{@from.name} with card number #{@card.number} and amount #{@card.amount}"
		@left = true
	end
	def readyToLeave(startTime)
		(@entered && !@left) &&(Time.now - startTime >= @leaveTime)
	end
end

class UserFactory
	def initialize(lines=[])
		@lines = lines
	end
	def nonTransfered(count)
		count.times.each_with_object([]) do |i, users|
			from, to = randomStation(randomLine)
			users<<User.new(from, to)
		end
	end
	private 
	def randomLine
		@lines[rand(@lines.length)]
	end
	def randomStation(line)
		from = to = rand(line.stations.length)
		to = rand(line.stations.length) until to != from
		to = to -2 if(to < from && to >= 2)
		to = to +2 if(to>from && to <line.stations.length-2)
		puts line.stations
		puts "#{from}, #{to}"
		return line.stations[from], line.stations[to]
	end
end