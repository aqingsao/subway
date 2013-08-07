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
		@entered, @left = false
		@enterTime, @leaveTime = enterTime, enterTime + 3 * 15 * 1
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
			line = randLine
			users<<User.new(line.stations[0], line.stations[10])
		end
	end
	private 
	def randLine
		@lines[rand(@lines.length)]
	end
end