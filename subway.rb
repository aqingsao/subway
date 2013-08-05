class Subway
	attr_reader :lines
	def initialize(lines = [])
		@lines = lines
		@stationIndex = 0
	end
	def addLine(line)
		@lines.push line
	end
	def nextStationIndex(stationName)
		station = getStationByName(stationName)
		station ==nil ? @stationIndex+=1 : station.index
	end
	def route(from, to)
		lines = []
		Route.new(lines)
	end
	private
	def getStationByName(stationName)
		line = @lines.detect{|line| line.contains(stationName)}
		line.getStationByName(stationName) unless line.nil?
	end
end

class Line
	attr_reader :name, :stations
	def initialize(name, stations = [])
		@name = name;
		@stations = stations
	end
	def addStation(station)
		@stations.push station
	end
	def getStationByName(stationName)
		@stations.detect {|station| station.name == stationName}
	end
	def contains(stationName)
		@stations.any?{|station| station.name == stationName}
	end
end

class Station
	attr_reader :index, :name
	def initialize(index, name)
		@index, @name = index, name
	end
end

class Route
	def initialize(lines)
		@lines = lines
	end

	def stationsCount
		count = 0;
		@lines.each{|line| count += line.stations.length}
		count
	end
end