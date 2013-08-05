require 'logger'
LOGGER = Logger.new(STDOUT)
# LOGGER = Logger.new('subway.log', 'daily')
LOGGER.datetime_format = "%Y-%m-%d\T%H:%M:%S"
LOGGER.formatter = proc { |severity, datetime, progname, msg|
  "#{datetime}: #{msg}\n"
}

class User
	def initialize(cardNo, location, office)
		@cardNo, @location, @office = cardNo, location, office
	end

	def visit(from, to)
		LOGGER.info from
	end
end