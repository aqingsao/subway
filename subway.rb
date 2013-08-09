require File.join(File.dirname(__FILE__), 'graph.rb')

class Subway
	attr_reader :lines, :graph, :routes
	def initialize(lines = [])
		@lines = lines
		@index_stations = {}
		@name_stations = {}
		@routes = Routes.new
	end
	def addLine(line)
		@lines.push line
	end
	def containsStation(station_name)
		@lines.any?{|line| line.containsStation(station_name)}
	end
	def station_by_name(station_name)
		line = @lines.detect{|line| line.containsStation(station_name)}
		line.station_by_name(station_name) unless line.nil?
	end
	def station_by_index(index)
		@index_stations[index]
	end
	def line_by_name(line_name)
		@lines.find{|line| line.name == line_name}
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
				@graph.connect_mutually(station.index, line.stations[index+1].index, 2.5) unless (index >= line.stations.length-1)
			end
		end
		@lines.each do |line|
			line.stations.each do |station|
				station.lines << line unless station.lines.include? line
			end
		end

		@routes = Routes.new
		@graph.init_routes().each do |route|
			@routes << Route.new(route.collect{|index| station_by_index(index)})
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
	def station_by_name(station_name)
		@stations.detect {|station| station.name == station_name}
	end
	def containsStation(station_name)
		@stations.any?{|station| station.name == station_name}
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

class Route
	attr_reader :stations, :lines
	def initialize(stations = [])
		@stations = stations
		@lines = calculate_lines()
	end
	def ==(other)
		return false unless self.stations.length == other.stations.length
		result = true;
		self.stations.each_with_index do |e, i|
			result = false unless (e == other.stations[i])
		end
		result
	end
	private 
	def calculate_lines
		lines = []
		currentLine = []
		stations.each do |station|
			if currentLine.empty?
				currentLine = station.lines
			else
				if (currentLine & station.lines) == []
					lines << currentLine.shift
					currentLine = station.lines
				else
					currentLine &= station.lines
				end
			end
		end
		lines << currentLine.first unless currentLine.empty?
		# p "route: #{stations.collect{|station| station.name}}"
		# p "line: #{lines.collect{|line| line.name}}"

		lines
	end
end

class Routes < Array
	def simple_routes
		self.collect{|route| route.stations.collect{|station| station.index}}
	end
	def routes_with_transfer(times)
		self.find_all{|route| route.lines.length == times + 1}
	end

	def route(src, dst)
		self.find do |route|
			return route if (route.stations.first.index == src && route.stations.last.index == dst)
		end
	end
end