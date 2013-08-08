require File.join(File.dirname(__FILE__), 'graph.rb')

class Subway
	attr_reader :lines, :graph
	def initialize(lines = [])
		@lines = lines
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
		routes = {}
		stations.each do |station|
			stations.each do |another|
				if(station != another)
					routes[[station.index, another.index]] = @graph.route(station.index, another.index)
				end
			end
		end
		p routes
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

# class Route
# 	attr_reader :edges
# 	def initialize(edges = [])
# 		@edges = edges
# 	end
# 	def ==(other)
# 		return false unless self.edges.length == other.edges.length
# 		result = true;
# 		self.edges.each_with_index do |e, i|
# 			result = false unless (e == other.edges[i])
# 		end
# 		result
# 	end
# end