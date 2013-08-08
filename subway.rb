require File.join(File.dirname(__FILE__), 'graph.rb')

class Subway
	attr_reader :lines, :graph
	def initialize(lines = [])
		@lines = lines
		@index_stations = {}
		@name_stations = {}
	end
	def addLine(line)
		@lines.push line
	end
	def containsStation(stationName)
		@lines.any?{|line| line.containsStation(stationName)}
	end
	def getStation(stationName)
		line = @lines.detect{|line| line.containsStation(stationName)}
		line.getStation(stationName) unless line.nil?
	end
	def getStationByIndex(index)
		@index_stations[index]
	end
	def maxStationIndex
		result = @lines.collect{|line| line.maxStationIndex}.max
		result.nil? ? 0 : result
	end
	def stations
		@lines.each_with_object([]){|line, stations| line.stations.each{|s| stations<<s} }.uniq
	end

	def marshal
		@lines.each do |line|
			line.stations.each do |station|
				station.transfer= true if @lines.any?{|l| l.containsStation(station.name) && l.name != line.name}
				@name_stations[station.name] = station
				@index_stations[station.index] = station
			end
		end
		@graph = Graph.new
		stations = stations()
		stations.collect{|station| station.index}.each do |vertex|
			@graph << vertex
		end
		@lines.each do |line|
			line.stations.each_with_index do |station, index|
				@graph.connect_mutually(station.index, line.stations[index+1].index, 1) unless (index >= line.stations.length-1)
			end
		end
		@lines.each do |line|
			line.stations.each do |station|
				station.lines << line unless station.lines.include? line
			end
		end

		@routes = {}
		@graph.init_routes().each_pair do |key, value|
			p "#{key}: #{value}"
			@routes[[getStationByIndex(key[0]), getStationByIndex(key[1])]] = Route.new(value.collect{|index| getStationByIndex(index)})
		end
		self
	end
end

class Line
	attr_reader :name, :stations
	def initialize(name, stations = [])
		@name, @stations = name, stations;
	end
	def addStation(station)
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
	def transferableLines
		lines = []
		@stations.find_all{|station| station.transfer==true}.each do |station|
			lines = lines + station.lines
		end
		lines.uniq - [self]
	end
	def ==(other)
		self.name == other.name
	end
end

class Station
	attr_reader :index, :name
	attr_accessor :transfer, :lines
	def initialize(index, name)
		@index, @name, @transfer, @lines = index, name, false, []
	end
	def ==(other)
		self.index == other.index && self.name == other.name
	end
end

# class Edge
# 	attr_reader :from, :to
# 	def initialize(from, to)
# 		@from, @to = from, to
# 	end

# 	def ==(other)
# 		(self.from == other.from) && (self.to== other.to)
# 	end
# end

class Route
	attr_reader :stations
	def initialize(stations = [])
		@stations = stations
	end
	def ==(other)
		return false unless self.stations.length == other.stations.length
		result = true;
		self.stations.each_with_index do |e, i|
			result = false unless (e == other.stations[i])
		end
		result
	end
end