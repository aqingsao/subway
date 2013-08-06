class Subway
	attr_reader :lines
	def initialize(lines = [])
		@lines = lines

		@stationIndex = 0
	end
	def addLine(line)
		@lines.push line
	end
	def route(from, to)
		lines = []
		Route.new(lines)
	end
	def containsStation(stationName)
		@lines.any?{|line| line.containsStation(stationName)}
	end
	def maxStationIndex
		result = @lines.collect{|line| line.maxStationIndex}.max
		result.nil? ? 0 : result
	end
end

class Line
	attr_reader :name, :stations
	def initialize(name, stations = [])
		@name, @stations = name, stations;
	end
	def addStation(station)
		puts "add #{station.index}: #{station.name} to line #{name}"
		@stations.push station
	end
	def getStationByName(stationName)
		@stations.detect {|station| station.name == stationName}
	end
	def containsStation(stationName)
		@stations.any?{|station| station.name == stationName}
	end
	def maxStationIndex
		result = @stations.collect{|station| station.index}.max
		result.nil? ? 0 : result
	end
end

class Station
	attr_reader :index, :name
	def initialize(index, name)
		@index, @name = index, name
	end
	def ==(other)
		self.index == other.index && self.name == other.name
	end
end

class Edge
	attr_reader :from, :to
	def initialize(from, to)
		@from, @to = from, to
	end

	def ==(other)
		((self.from == other.from) && (self.to== other.to)) || ((self.from== other.to) && (self.to== other.from))
	end
end

class Route
	attr_reader :edges
	def initialize(edges = [])
		@edges = edges
	end
	def ==(other)
		return false unless self.edges.length == other.edges.length
		result = true;
		self.edges.each_with_index do |e, i|
			result = false unless (e == other.edges[i])
		end
		result
	end
end