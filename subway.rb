require File.join(File.dirname(__FILE__), 'graph.rb')

class Subway
	attr_reader :lines, :graph, :routes
	def initialize(lines = [])
		@lines = lines
		@routes = Routes.new
	end
	def addLine(line)
		@lines.push line
	end
	def containsStation(station_name)
		@lines.any?{|line| line.containsStation(station_name)}
	end
	def station_by_name(station_name)
		@lines.each do |line|
			line.stations.each do |station|
				return station if station.name == station_name
			end
		end
		nil
	end
	def station_by_index(station_index)
		@lines.each do |line|
			line.stations.each do |station|
				return station if station.index == station_index
			end
		end
		nil
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
