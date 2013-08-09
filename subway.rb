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
				station.lines << line unless station.lines.include? line
				station.transfer= true if @lines.any?{|l| l.containsStation(station.name) && l.name != line.name}
				@name_stations[station.name] = station
				@index_stations[station.index] = station
			end
		end

		@graph = Graph.new
		@lines.each do |line|
			line.stations.each_with_index do |station, index|
				@graph.connect_mutually(station.index, line.stations[index+1].index, 2.5) unless (index >= line.stations.length-1)
			end
		end
		@routes = Routes.new
		@graph.init_routes().each do |route|
			@routes << Route.new(route.collect{|index| station_by_index(index)})
		end
		self
	end
end
