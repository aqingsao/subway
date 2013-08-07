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
	def initialize(from, to, enterTime=5, card=Card.new)
		@card, @from, @to, @offTime = card, from, to, enterTime
		@entered, @outed = false
		@enterTime, @outTime = enterTime, enterTime + 3 * 15 * 1
	end

	def finished
		@entered && @outed
	end
	def enter
		LOGGER.info "card #{@card.number} entered station #{@from.name} with amount #{@card.amount}"
		@entered = true
	end
	def readyToEnter(startTime)
		!@entered && (Time.now - startTime >= @enterTime)
	end
	def out
		@card.amount = @card.amount - 2
		LOGGER.info "card #{@card.number} got out station #{@from.name} with amount #{@card.amount}"
		@outed = true
	end
	def readyToOut(startTime)
		(@entered && !@outed) &&(Time.now - startTime >= @outTime)
	end
end

class UserFactory
	def initialize(lines=[])
		@lines = lines
	end
	def nonTransfered(count)
		count.times.each_with_object([]) do |i, users|
			line = randLine
			users<<User.new(line.stations[0], line.stations[10])
		end
	end
	private 
	def randLine
		@lines[rand(@lines.length)]
	end
end