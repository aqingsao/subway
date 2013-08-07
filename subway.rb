class Subway
	attr_reader :lines
	def initialize(lines = [])
		@lines = lines
	end
	def addLine(line)
		@lines.push line
	end
	def calculateRoute(from, to)
		lines = []
		Route.new(lines)
	end
	def containsStation(stationName)
		@lines.any?{|line| line.containsStation(stationName)}
	end
	def getStation(stationName)
		line = @lines.detect{|line| line.containsStation(stationName)}
		line.getStation(stationName) unless line.nil?
	end
	def maxStationIndex
		result = @lines.collect{|line| line.maxStationIndex}.max
		result.nil? ? 0 : result
	end

	def afterBuild
		@lines.each do |line|
			line.stations.each do |station|
				station.transformed= true if @lines.any?{|l| l.containsStation(station.name) && l.name != line.name}
			end
		end
	end
	private
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
	def getStation(stationName)
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
	attr_accessor :transformed
	def initialize(index, name)
		@index, @name, @transformed = index, name, false
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
		(self.from == other.from) && (self.to== other.to)
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