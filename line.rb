
require File.join(File.dirname(__FILE__), 'station.rb')

class Line
	attr_reader :name, :stations
	def initialize(name, stations = [])
		@name = name
		@stations = []
		stations.each{|station|add_station(station)}
	end
	def add_station(station)
		@stations.push station
		station.lines << self unless station.lines.include? self
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
		@stations.each do |station|
			lines = lines + station.lines
		end
		lines.uniq - [self]
	end
	def ==(other)
		self.name == other.name
	end
end
