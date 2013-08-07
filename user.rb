require 'logger'
LOGGER = Logger.new(STDOUT)
# LOGGER = Logger.new('subway.log', 'daily')
LOGGER.datetime_format = "%Y-%m-%d\T%H:%M:%S"
LOGGER.formatter = proc { |severity, datetime, progname, msg|
  "#{datetime}: #{msg}\n"
}

class User
	def initialize(cardNo, from, to, enterTime=5)
		@cardNo, @from, @to, @offTime = cardNo, from, to, enterTime
		@entered, @outed = false
		@enterTime, @outTime = enterTime, enterTime + 3 * 15 * 60
	end

	def finished
		@entered && @outed
	end
	def enter
		LOGGER.info "#{@cardNo} entered station #{@from.name}"
		@entered = true
	end
	def readyToEnter(startTime)
		!@entered && (Time.now - startTime >= @enterTime)
	end
	def out
		LOGGER.info "#{@cartNo} got out station #{@from.name}"
		@outed = true
	end
	def readyToOut(startTime)
		(@entered && !@outed) && (Time.now - startTime >= @outTime)
	end
end

class Users < Array
	def remaining
		return self.find_all{|user| !user.finished}
	end
	def allFinished
		self.all? {|user| user.finished}
	end
end